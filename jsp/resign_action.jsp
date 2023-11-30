<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    Object id_value_ob = session.getAttribute("id_value");
    String id_value = String.valueOf(id_value_ob);
    if(id_value_ob == null){
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }
    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");
    
        String sql = "DELETE FROM user WHERE id= ?";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, id_value);
        query.executeUpdate();
    }catch(Exception e){
        e.printStackTrace();
    }
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        alert("탈퇴되었습니다.")
        location.href="/week09/jsp/log_in.jsp"
    </script>
</body>