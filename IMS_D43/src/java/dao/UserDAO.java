package dao;

import model.User;
import util.DBConnection;
import java.sql.*;

/**
 * User Data Access Object – handles authentication and user queries.
 * @author id43
 */
public class UserDAO {

    /**
     * Authenticate a user and return the full User object (with role).
     * Returns null if credentials are invalid.
     */
    public User authenticate(String username, String password) throws Exception {
        String sql = "SELECT id, username, role FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("role")
                );
            }
        }
        return null;
    }

    /**
     * Simple boolean check – kept for backward compatibility.
     */
    public boolean validateUser(String username, String password) throws Exception {
        return authenticate(username, password) != null;
    }
}