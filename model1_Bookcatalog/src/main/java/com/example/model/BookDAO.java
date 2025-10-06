package com.example.model;

import java.sql.*;
import java.util.*;
import com.example.model.Book;

public class BookDAO {
    // Database configuration
    private final String URL  = "jdbc:mysql://localhost:3306/librarydb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private final String USER = "root";
    private final String PASS = "slrt";

    // Connection helper
    private Connection getConn() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // ✅ Fetch all books (newest first)
    public List<Book> findAll() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT id, title, author, price FROM books ORDER BY id ASC";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Book(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getDouble("price")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Insert a new book
    public int insert(Book b) {
        String sql = "INSERT INTO books(title, author, price) VALUES (?, ?, ?)";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setDouble(3, b.getPrice());
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Find book by ID
    public Book findById(int id) {
        String sql = "SELECT id, title, author, price FROM books WHERE id=?";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Book(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getDouble("price")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Update existing book
    public int update(Book b) {
        String sql = "UPDATE books SET title=?, author=?, price=? WHERE id=?";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setDouble(3, b.getPrice());
            ps.setInt(4, b.getId());
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Delete a book by ID
    public int delete(int id) {
        String sql = "DELETE FROM books WHERE id=?";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
