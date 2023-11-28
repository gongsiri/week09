<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    int schedule_key = Integer.parseInt(request.getParameter("key_input"));

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

    String sql = "DELETE FROM schedule WHERE schedule_key= ?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setInt(1, schedule_key);

    query.executeUpdate();
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        alert("게시물을 삭제했습니다.")
        location.href="/week09/jsp/main.jsp"
    </script>
</body>