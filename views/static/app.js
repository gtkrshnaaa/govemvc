let ws;
const wsStatusDot = document.getElementById("wsStatusDot");
const wsStatusText = document.getElementById("wsStatusText");
const todoList = document.getElementById("todoList");
const todoForm = document.getElementById("todoForm");
const todoTitle = document.getElementById("todoTitle");

// Connect to the native WebSocket server
function connectWS() {
    const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
    const wsUrl = `${protocol}//${window.location.host}/ws`;
    ws = new WebSocket(wsUrl);

    ws.onopen = () => {
        wsStatusDot.className = "status-dot connected";
        wsStatusText.textContent = "Live Connected";
    };

    ws.onclose = () => {
        wsStatusDot.className = "status-dot disconnected";
        wsStatusText.textContent = "Disconnected (Reconnecting...)";
        setTimeout(connectWS, 2000);
    };

    ws.onerror = (err) => {
        console.error("websocket error:", err);
        ws.close();
    };

    ws.onmessage = (event) => {
        const data = JSON.parse(event.data);
        handleWSMessage(data);
    };
}

// Handle real-time updates from WebSocket broadcast
function handleWSMessage(data) {
    if (data.event === "create") {
        removeEmptyState();
        if (!document.getElementById(`todo-${data.todo.id}`)) {
            const li = createTodoDOM(data.todo);
            todoList.insertAdjacentHTML("afterbegin", li);
        }
    } else if (data.event === "toggle") {
        const item = document.getElementById(`todo-${data.todo.id}`);
        if (item) {
            const checkbox = item.querySelector(".todo-checkbox");
            checkbox.checked = data.todo.completed;
            if (data.todo.completed) {
                item.classList.add("completed");
            } else {
                item.classList.remove("completed");
            }
        }
    } else if (data.event === "delete") {
        const item = document.getElementById(`todo-${data.todo.id}`);
        if (item) {
            item.classList.add("deleting");
            item.remove();
            checkEmptyState();
        }
    }
}

// Generate Todo item HTML
function createTodoDOM(todo) {
    return `
        <li class="todo-item ${todo.completed ? 'completed' : ''}" data-id="${todo.id}" id="todo-${todo.id}">
            <label class="todo-label">
                <input type="checkbox" class="todo-checkbox" ${todo.completed ? 'checked' : ''} onchange="toggleTodo(${todo.id}, this.checked)">
                <span class="todo-text">${escapeHTML(todo.title)}</span>
            </label>
            <button class="btn-delete" onclick="deleteTodo(${todo.id})">Delete</button>
        </li>
    `;
}

// Helper to escape HTML tags to prevent client-side XSS
function escapeHTML(str) {
    return str.replace(/[&<>'"]/g, 
        tag => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[tag] || tag)
    );
}

function removeEmptyState() {
    const empty = document.getElementById("emptyState");
    if (empty) {
        empty.remove();
    }
}

function checkEmptyState() {
    if (todoList.children.length === 0) {
        todoList.innerHTML = `<li class="empty-state" id="emptyState">No tasks yet. Create one above!</li>`;
    }
}

// Asynchronously toggle todo status via API
async function toggleTodo(id, completed) {
    try {
        const response = await fetch(`/todos/${id}/toggle`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ completed })
        });
        if (!response.ok) {
            console.error("failed to toggle todo status");
        }
    } catch (err) {
        console.error("network error toggling status:", err);
    }
}

// Asynchronously delete todo via API
async function deleteTodo(id) {
    try {
        const response = await fetch(`/todos/${id}`, {
            method: "DELETE"
        });
        if (!response.ok) {
            console.error("failed to delete todo");
        }
    } catch (err) {
        console.error("network error deleting todo:", err);
    }
}

// Intercept form submission to add new task asynchronously
if (todoForm) {
    todoForm.onsubmit = async (e) => {
        e.preventDefault();
        const title = todoTitle.value.trim();
        if (!title) return;

        try {
            const formData = new FormData();
            formData.append("title", title);

            const response = await fetch("/todos", {
                method: "POST",
                body: formData
            });

            if (response.ok) {
                todoTitle.value = "";
                todoTitle.focus();
            } else {
                console.error("failed to create todo");
            }
        } catch (err) {
            console.error("network error creating todo:", err);
        }
    };
}

// Initialize connection
connectWS();
