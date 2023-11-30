<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    Object key_value_ob = session.getAttribute("key_value");
    if(key_value_ob == null){
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }
    int key_value = Integer.parseInt(key_value_ob.toString());
    int session_value = Integer.parseInt(request.getParameter("session_input"));
    int schedule_key = Integer.parseInt(request.getParameter("key_input"));

    if(key_value != session_value){ // 현재 로그인된 사람과 일정의 소유자가 다르다면
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }

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
        location.href="/week09/jsp/main.jsp"
    </script>
</body>