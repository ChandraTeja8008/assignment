<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.example.model.BookDAO, com.example.model.Book" %>
<%
    request.setCharacterEncoding("UTF-8");
    BookDAO dao = new BookDAO();
    String action = request.getParameter("action");

    // === CREATE ===
    if ("insert".equals(action)) {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String priceStr = request.getParameter("price");

        if (title != null && author != null && priceStr != null && 
            !title.isBlank() && !author.isBlank()) {
            try {
                double price = Double.parseDouble(priceStr);
                dao.insert(new Book(0, title.trim(), author.trim(), price));
                request.setAttribute("msg", "✅ Book added successfully.");
            } catch (Exception ex) {
                request.setAttribute("err", "❌ Insert failed: " + ex.getMessage());
            }
        } else {
            request.setAttribute("err", "⚠️ All fields are required.");
        }
        action = "list";
    }

    // === UPDATE ===
    if ("update".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            double price = Double.parseDouble(request.getParameter("price"));
            dao.update(new Book(id, title, author, price));
            request.setAttribute("msg", "✅ Book updated successfully.");
        } catch (Exception ex) {
            request.setAttribute("err", "❌ Update failed: " + ex.getMessage());
        }
        action = "list";
    }

    // === DELETE ===
    if ("delete".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
            request.setAttribute("msg", "🗑️ Book deleted successfully.");
        } catch (Exception ex) {
            request.setAttribute("err", "❌ Delete failed: " + ex.getMessage());
        }
        action = "list";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Assignment</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
        font-family: 'Poppins', sans-serif;
        background: #f7fafc;
        color: #333;
        padding: 20px;
    }
    h3, h2 { color: #00796b; }
    .container { max-width: 1000px; margin: auto; }

    .msg, .err {
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 16px;
        font-weight: 500;
    }
    .msg { background: #e0f7fa; color: #00796b; border: 1px solid #80deea; }
    .err { background: #ffebee; color: #c62828; border: 1px solid #ef9a9a; }

    .box {
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        padding: 24px;
        margin: 20px 0;
    }

    label { font-weight: 600; color: #555; }
    input[type=text] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        margin-top: 4px;
        margin-bottom: 12px;
        font-size: 15px;
    }
    input[type=text]:focus {
        border-color: #00796b;
        outline: none;
        box-shadow: 0 0 5px rgba(0,121,107,0.2);
    }

    .btn {
        padding: 8px 14px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        transition: all 0.3s ease;
    }
    button.btn {
        background: #00796b;
        color: #fff;
    }
    button.btn:hover { background: #004d40; }
    a.btn {
        background: #e0f2f1;
        color: #004d40;
        text-decoration: none;
        display: inline-block;
        border-radius: 8px;
        padding: 8px 14px;
        margin-left: 6px;
    }
    a.btn:hover { background: #b2dfdb; }

    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    th, td {
        padding: 12px 10px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }
    th {
        background: #004d40;
        color: #fff;
        text-transform: uppercase;
        font-size: 14px;
    }
    tr:hover { background: #f1f1f1; }

    form.inline { display: inline; }

    @media (max-width: 768px) {
        body { padding: 10px; }
        table, thead, tbody, th, td, tr {
            display: block;
        }
        table tr {
            margin-bottom: 15px;
            background: #fff;
            border-radius: 10px;
            padding: 12px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
        }
        table th { display: none; }
        table td {
            border: none;
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
        }
        table td::before {
            content: attr(data-label);
            font-weight: 600;
            color: #00796b;
        }
    }
</style>
</head>
<body>
<div class="container">

<% if (request.getAttribute("msg") != null) { %>
  <div class="msg"><%= request.getAttribute("msg") %></div>
<% } %>
<% if (request.getAttribute("err") != null) { %>
  <div class="err"><%= request.getAttribute("err") %></div>
<% } %>

<%
    // === EDIT FORM ===
    if ("edit".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Book b = dao.findById(id);
            if (b == null) { request.setAttribute("err","Record not found"); action = "list"; }
            else {
%>
<div class="box">
  <h3>✏️ Edit Book</h3>
  <form method="post" action="books.jsp">
    <input type="hidden" name="action" value="update"/>
    <input type="hidden" name="id" value="<%= b.getId() %>"/>
    <label>Title</label>
    <input type="text" name="title" value="<%= b.getTitle() %>" required>
    <label>Author</label>
    <input type="text" name="author" value="<%= b.getAuthor() %>" required>
    <label>Price</label>
    <input type="text" name="price" value="<%= b.getPrice() %>" required>
    <button class="btn" type="submit">Update</button>
    <a class="btn" href="books.jsp?action=list">Cancel</a>
  </form>
</div>
<%
            }
        } catch (Exception ex) {
            request.setAttribute("err","Edit load failed: "+ex.getMessage());
            action = "list";
        }
    }
%>

<%
    // === LIST VIEW ===
    if (action == null || "list".equals(action)) {
        List<Book> books = dao.findAll();
%>
<div class="box">
  <h3>Add New Book</h3><br>
  <form method="post">
    <input type="hidden" name="action" value="insert"/>
    <label>Title</label>
    <input type="text" name="title" required>
    <label>Author</label>
    <input type="text" name="author" required>
    <label>Price</label>
    <input type="text" name="price" required>
    <button class="btn" type="submit">Add Book</button>
  </form>
</div>

<h3>Book List</h3><br>
<table>
  <thead>
    <tr><th>S.No</th><th>Title</th><th>Author</th><th>Price</th><th>Actions</th></tr>
  </thead>
  <tbody>
    <%
        int index = 1; // ✅ Correct indexing starts from 1
        for (Book b : books) {
    %>
      <tr>
        <td data-label="S.No"><%= index++ %></td>
        <td data-label="Title"><%= b.getTitle() %></td>
        <td data-label="Author"><%= b.getAuthor() %></td>
        <td data-label="Price">₹<%= b.getPrice() %></td>
        <td data-label="Actions">
          <a class="btn" href="books.jsp?action=edit&id=<%= b.getId() %>">Edit</a>
          <form class="inline" method="post" action="books.jsp" onsubmit="return confirm('Delete this book?');">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="id" value="<%= b.getId() %>"/>
            <button class="btn" type="submit" style="background:#d32f2f;">Delete</button>
          </form>
        </td>
      </tr>
    <% } %>
  </tbody>
</table>
<% } %>

</div>
</body>
</html>
