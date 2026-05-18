package websocket

import (
	"crypto/sha1"
	"encoding/base64"
	"fmt"
	"net"
	"net/http"
	"sync"
)

// Client represents a connected websocket client.
type Client struct {
	Conn net.Conn
	Send chan []byte
}

// Hub manages active connections and broadcasts.
type Hub struct {
	Clients    map[*Client]bool
	Broadcast  chan []byte
	Register   chan *Client
	Unregister chan *Client
	mu         sync.RWMutex
}

// ActiveHub is the global real-time coordinator.
var ActiveHub = &Hub{
	Clients:    make(map[*Client]bool),
	Broadcast:  make(chan []byte),
	Register:   make(chan *Client),
	Unregister: make(chan *Client),
}

// Start runs the hub communication loops.
func (h *Hub) Start() {
	for {
		select {
		case client := <-h.Register:
			h.mu.Lock()
			h.Clients[client] = true
			h.mu.Unlock()
		case client := <-h.Unregister:
			h.mu.Lock()
			if _, ok := h.Clients[client]; ok {
				delete(h.Clients, client)
				close(client.Send)
			}
			h.mu.Unlock()
		case message := <-h.Broadcast:
			h.mu.RLock()
			for client := range h.Clients {
				select {
				case client.Send <- message:
				default:
					h.mu.RUnlock()
					h.mu.Lock()
					delete(h.Clients, client)
					close(client.Send)
					h.mu.Unlock()
					h.mu.RLock()
				}
			}
			h.mu.RUnlock()
		}
	}
}

// Upgrade upgrades the HTTP connection to WebSocket manually using http.Hijacker.
func Upgrade(w http.ResponseWriter, r *http.Request) (net.Conn, error) {
	if r.Header.Get("Upgrade") != "websocket" {
		return nil, fmt.Errorf("invalid upgrade header")
	}

	key := r.Header.Get("Sec-WebSocket-Key")
	if key == "" {
		return nil, fmt.Errorf("missing Sec-WebSocket-Key")
	}

	guid := "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
	h := sha1.New()
	h.Write([]byte(key + guid))
	acceptKey := base64.StdEncoding.EncodeToString(h.Sum(nil))

	hijacker, ok := w.(http.Hijacker)
	if !ok {
		return nil, fmt.Errorf("webserver does not support hijacking")
	}

	conn, bufrw, err := hijacker.Hijack()
	if err != nil {
		return nil, fmt.Errorf("failed to hijack connection: %w", err)
	}

	response := fmt.Sprintf(
		"HTTP/1.1 101 Switching Protocols\r\n"+
			"Upgrade: websocket\r\n"+
			"Connection: Upgrade\r\n"+
			"Sec-WebSocket-Accept: %s\r\n\r\n",
		acceptKey,
	)

	_, err = bufrw.WriteString(response)
	if err != nil {
		conn.Close()
		return nil, fmt.Errorf("failed to write handshake response: %w", err)
	}
	bufrw.Flush()

	return conn, nil
}

// WriteFrame formats and writes a text frame to the connection.
func WriteFrame(conn net.Conn, payload []byte) error {
	length := len(payload)
	var header []byte

	header = append(header, 0x81)

	if length <= 125 {
		header = append(header, byte(length))
	} else if length <= 65535 {
		header = append(header, 126)
		header = append(header, byte(length>>8))
		header = append(header, byte(length&0xFF))
	} else {
		header = append(header, 127)
		for i := 7; i >= 0; i-- {
			header = append(header, byte(length>>(i*8)))
		}
	}

	if _, err := conn.Write(append(header, payload...)); err != nil {
		return err
	}
	return nil
}

// ReadLoop reads from connection to detect close frames and discard data.
func (c *Client) ReadLoop() {
	defer func() {
		ActiveHub.Unregister <- c
		c.Conn.Close()
	}()

	buf := make([]byte, 1024)
	for {
		n, err := c.Conn.Read(buf)
		if err != nil {
			break
		}

		if n > 0 {
			opcode := buf[0] & 0x0F
			if opcode == 8 {
				break
			}
		}
	}
}

// WriteLoop writes messages to the client connection.
func (c *Client) WriteLoop() {
	defer func() {
		c.Conn.Close()
	}()

	for msg := range c.Send {
		if err := WriteFrame(c.Conn, msg); err != nil {
			break
		}
	}
}
