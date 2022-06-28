package com.rhms;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Objects;

public class RHMSDAO {
    private static final String url = "jdbc:mysql://localhost:3306/projects", user = "root", passwd = "";
    private static String query;
    protected static String page = null;
    protected static int iTotRslts = 0;

    private static Connection conn;
    private static PreparedStatement st, psPgintn, psRwCn;
    private static ResultSet rsRwCn, rsPgin;

    private static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, passwd);
    }

    protected static boolean insert(House house) throws SQLException {
        try {
            conn = getConnection();
            query = "INSERT INTO houses (building, location, rent, descr, " +
                    "houseno, phonenumber, link, state, username, image) VALUES(?,?,?,?,?,?,?,?,?,?)";
            st = conn.prepareStatement(query);
            st.setString(1, house.getBuilding());
            st.setString(2, house.getLocation());
            st.setString(3, house.getRent());
            st.setString(4, house.getDescr());
            st.setString(5, house.getHouseNo());
            st.setString(6, house.getPhoneNumber());
            st.setString(7, house.getLink());
            st.setString(8, house.getState());
            st.setString(9, house.getUsername());
            st.setString(10, house.getImage());
            st.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            st.close();
            conn.close();
        }
        return true;
    }

    protected static boolean insert(String username, String email, String password) throws SQLException {
        try {
            conn = getConnection();
            query = "INSERT INTO house_users(username, email, password) VALUES (?,?,?)";
            st = conn.prepareStatement(query);
            st.setString(1, username);
            st.setString(2, email);
            st.setString(3, password);
            st.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            st.close();
            conn.close();
        }
        return true;
    }

    protected static List<House> select(int iPagNo, int iSwRws, String attrParam) throws SQLException {
        List<House> houses = new ArrayList<>();
        try {
            House house;
            conn = getConnection();
            Restrict restrict = Restrict.getRestrict();
            switch (restrict) {
                case ADMIN:
                case HOME:
                case USERS:
                case GUEST:
                    page = "houses.jsp";
                    query = restrict == Restrict.ADMIN ?
                            "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = house_users.username limit ?,?" :
                            "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = house_users.username where state <> 'Sold' limit ?,?";
                    psPgintn = conn.prepareStatement(query);
                    psPgintn.setInt(1, iPagNo);
                    psPgintn.setInt(2, iSwRws);
                    break;
                case ME:
                    page = "myHouses.jsp";
                    query = "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = house_users.username where houses.username = ? limit ?,?";
                    psPgintn = conn.prepareStatement(query);
                    //psPgintn.setString(1, getRequest().getSession().getAttribute("username").toString());
                    psPgintn.setString(1, attrParam);
                    psPgintn.setInt(2, iPagNo);
                    psPgintn.setInt(3, iSwRws);
                    break;
                case SEARCH:
                    page = "search.jsp";
                    query = "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = house_users.username where state <> 'Sold' and concat" +
                            "(houses.username, building, location, descr, houseno, state, phonenumber) like ? limit ?,?";
                    psPgintn = conn.prepareStatement(query);
                    //psPgintn.setString(1, "%" + getRequest().getParameter("searchTerm") + "%");
                    psPgintn.setString(1, "%" + attrParam + "%");
                    psPgintn.setInt(2, iPagNo);
                    psPgintn.setInt(3, iSwRws);
                    break;
                case FILTER:
                    String[] paramSplit = attrParam.split("\\|");
                    switch (Restrict.getSubRestrict()) {
                        case USERS:
                            query = paramSplit[2].equalsIgnoreCase("all") ?
                                    "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = " +
                                            "house_users.username where rent >= ? and rent <= ? " +
                                            "and state <> 'Sold' limit ?, ?;" :
                                    "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = " +
                                            "house_users.username where rent >= ? and rent <= ? " +
                                            "and location = ? and state <> 'Sold' limit ?, ?;";
                            psPgintn = conn.prepareStatement(query);
                            psPgintn.setInt(1, Integer.parseInt(paramSplit[0]));
                            psPgintn.setInt(2, Integer.parseInt(paramSplit[1]));
                            if (!paramSplit[2].equalsIgnoreCase("all")) {
                                psPgintn.setString(3, paramSplit[2]);
                                psPgintn.setInt(4, iPagNo);
                                psPgintn.setInt(5, iSwRws);
                            } else {
                                psPgintn.setInt(3, iPagNo);
                                psPgintn.setInt(4, iSwRws);
                            }
                            break;
                        case ME:
                            query = paramSplit[2].equalsIgnoreCase("all") ?
                                    "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = " +
                                            "house_users.username where rent >= ? and rent <= ? and houses.username = ? limit ?, ?;" :
                                    "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = " +
                                            "house_users.username where rent >= ? and rent <= ? and houses.username = ?" +
                                            " and location = ? limit ?, ?;";
                            psPgintn = conn.prepareStatement(query);
                            psPgintn.setInt(1, Integer.parseInt(paramSplit[0]));
                            psPgintn.setInt(2, Integer.parseInt(paramSplit[1]));
                            psPgintn.setString(3, paramSplit[3]);
                            if (paramSplit[2].equalsIgnoreCase("all")) {
                                psPgintn.setInt(4, iPagNo);
                                psPgintn.setInt(5, iSwRws);
                            } else {
                                psPgintn.setString(4, paramSplit[2]);
                                psPgintn.setInt(5, iPagNo);
                                psPgintn.setInt(6, iSwRws);
                            }
                            break;
                        case SEARCH:
                            query = paramSplit[2].equalsIgnoreCase("all") ?
                                    "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = house_users.username where rent >= ? and rent <= ?" +
                                            " and state <> 'Sold' and concat(houses.username, building, location, descr, houseno, state, phonenumber) " +
                                            "like ? limit ?, ?;" :
                                    "SELECT SQL_CALC_FOUND_ROWS *, house_users.email FROM houses left join house_users on houses.username = house_users.username where rent >= ? and rent <= ?" +
                                            " and state <> 'Sold' and location = ? and " +
                                            "concat(houses.username, building, location, descr, houseno, state, phonenumber) like ? limit ?, ?;";
                            psPgintn = conn.prepareStatement(query);
                            psPgintn.setInt(1, Integer.parseInt(paramSplit[0]));
                            psPgintn.setInt(2, Integer.parseInt(paramSplit[1]));
                            if (paramSplit[2].equalsIgnoreCase("all")) {
                                psPgintn.setString(3, "%" + paramSplit[4] + "%");
                                psPgintn.setInt(4, iPagNo);
                                psPgintn.setInt(5, iSwRws);
                            } else {
                                psPgintn.setString(3, paramSplit[2]);
                                psPgintn.setString(4, "%" + paramSplit[4] + "%");
                                psPgintn.setInt(5, iPagNo);
                                psPgintn.setInt(6, iSwRws);
                            }
                            break;
                    }
                    break;
            }
            rsPgin = psPgintn.executeQuery();
            //System.out.println("PREPARED STATEMENT: " + psPgintn);
            String sqlRwCnt = "SELECT FOUND_ROWS() as cnt";
            psRwCn = conn.prepareStatement(sqlRwCnt);
            rsRwCn = psRwCn.executeQuery();

            if (rsRwCn.next()) {
                iTotRslts = rsRwCn.getInt("cnt");
            }
            while (rsPgin.next()) {
                house = new House();
                house.setImage(rsPgin.getString("image"));
                house.setLink(rsPgin.getString("link"));
                house.setUsername(rsPgin.getString("username"));
                house.setBuilding(rsPgin.getString("building"));
                house.setLocation(rsPgin.getString("location"));
                house.setRent(rsPgin.getString("rent"));
                house.setDescr(rsPgin.getString("descr"));
                house.setHouseNo(rsPgin.getString("houseno"));
                house.setPhoneNumber(rsPgin.getString("phonenumber"));
                house.setState(rsPgin.getString("state"));
                house.setEmail(rsPgin.getString("email"));
                houses.add(house);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            psPgintn.close();
            psRwCn.close();
            rsRwCn.close();
            rsPgin.close();
            conn.close();
        }
        return houses;
    }


    protected static int update(House house) throws SQLException {
        try {
            conn = getConnection();
            query = "update houses set rent=?, state=? where username=? and houseno = ?";
            st = conn.prepareStatement(query);
            st.setString(1, house.getRent());
            st.setString(2, house.getState());
            st.setString(3, house.getUsername());
            st.setString(4, house.getHouseNo());
            st.executeUpdate();
            return st.getUpdateCount();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            st.close();
            conn.close();
        }
    }

    protected static int update(String param, String oldPassword, String newPassword, boolean email) throws SQLException {
        try {
            conn = getConnection();
            query = email ? "UPDATE house_users SET password = ?  WHERE email = ? AND password = ?" :
                    "UPDATE house_users SET password = ?  WHERE username = ? AND password = ?";
            st = conn.prepareStatement(query);
            st.setString(1, newPassword);
            st.setString(2, param);
            st.setString(3, oldPassword);
            st.executeUpdate();
            //System.out.println(st);
            return st.getUpdateCount();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            conn.close();
            st.close();
        }
    }

    protected static int delete(House house) throws SQLException {
        try {
            conn = getConnection();
            st = conn.prepareStatement("delete from houses where houseno = ? and username=?");
            st.setString(1, house.getHouseNo());
            st.setString(2, house.getUsername());
            st.executeUpdate();
            return st.getUpdateCount();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            conn.close();
            st.close();
        }
        return -1;
    }

    protected static int delete(String username) throws SQLException {
        try {
            conn = getConnection();
            st = conn.prepareStatement("delete from houses where username = ?");
            st.setString(1, username);
            st.executeUpdate();
            st = conn.prepareStatement("delete from house_users where username = ?");
            st.setString(1, username);
            st.executeUpdate();
            return st.getUpdateCount();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            conn.close();
            st.close();
        }
        return -1;
    }

    protected static String encrypt(String password) {
        try {
            String key = "so when the saints go marchingin";
            Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.ENCRYPT_MODE, aesKey);
            return Base64.getEncoder().encodeToString(cipher.doFinal(password.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException | NoSuchPaddingException |
                 InvalidKeyException | IllegalBlockSizeException | BadPaddingException e) {
            e.printStackTrace();
        }
        return null;
    }

    protected static String[] login(String param, String password, boolean email) throws IOException, SQLException {
        ResultSet rs = null;
        try {
            String dbemail, dbpassword;
            password = encrypt(password);
            conn = getConnection();
            st = conn.prepareStatement(email ? "select * from house_users where email=? AND password=?" :
                    "select * from house_users where username=? AND password=?"); //sql select query
            st.setString(1, param);
            st.setString(2, password);

            rs = st.executeQuery();
            if (rs.next()) {
                dbemail = email ? rs.getString("email") : rs.getString("username");
                dbpassword = rs.getString("password");
                return param.equalsIgnoreCase(dbemail) && Objects.equals(password, dbpassword) ? new String[]{param, password} : null;
            }
        } catch (SQLException | ClassNotFoundException e) {
            //out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            st.close();
            conn.close();
        }
        return null;
    }

    protected static String getPasswd(String email) throws SQLException {
        ResultSet rs = null;
        try {
            conn = getConnection();
            st = conn.prepareStatement("select * from house_users where email=?");
            st.setString(1, email);
            rs = st.executeQuery();
            if (rs.next()) {
                String key = "so when the saints go marchingin";
                Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
                Cipher cipher = Cipher.getInstance("AES");
                cipher.init(Cipher.DECRYPT_MODE, aesKey);
                return new String(cipher.doFinal(Base64.getDecoder().decode(rs.getString(2))));
            }
        } catch (ClassNotFoundException | SQLException | InvalidKeyException |
                 NoSuchPaddingException | IllegalBlockSizeException |
                 NoSuchAlgorithmException | BadPaddingException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            st.close();
            conn.close();
        }
        return null;
    }
}
