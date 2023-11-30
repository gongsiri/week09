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
    int session_value = Integer.parseInt(request.getParameter("session_value"));
    String apm_value = request.getParameter("input_apm_value");
    int hour_value = Integer.parseInt(request.getParameter("input_hour_value"));
    int minute_value = Integer.parseInt(request.getParameter("input_minute_value"));
    int year_value = Integer.parseInt(request.getParameter("year_value"));
    int month_value = Integer.parseInt(request.getParameter("month_value"));
    int day_value = Integer.parseInt(request.getParameter("day_value"));
    String content_value = request.getParameter("content_value");

    if(key_value !=session_value){ // 현재 로그인 된 사람과 일정의 소유자가 다를 때
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }

    if("PM".equals(apm_value)){ // pm일 경우
        if(hour_value !=12){
            hour_value = hour_value + 12;
        }
    }
    else if("AM".equals(apm_value) && hour_value == 12){ // 12 am일 경우
        hour_value = 0;
    }
    
    String date_value = year_value + "-" + month_value + "-" + day_value + " " + hour_value + ":" + minute_value + ":00"; // timestamp 형식으로
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

    String sql = "INSERT INTO schedule (user_key, date, content) VALUES (?,?,?)";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setInt(1,key_value);
    query.setString(2,date_value);
    query.setString(3,content_value);
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
