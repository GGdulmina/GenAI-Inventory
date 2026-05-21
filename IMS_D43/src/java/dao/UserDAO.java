package dao;

import util.DBConnection;
import java.sql.*;

public class UserDAO {

    public boolean validateUser(String username, String password) throws Exception {
        String sql = "SELECT id FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true if a matching row exists
        }
    }
}