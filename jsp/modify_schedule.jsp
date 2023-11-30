<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<%
    Object session_key_value_ob = session.getAttribute("key_value");
    if(session_key_value_ob == null){
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }
    int session_key_value = Integer.parseInt(session_key_value_ob.toString());
    int session_value = Integer.parseInt(request.getParameter("session_input"));
    String apm_value = request.getParameter("apm_input");
    int hour_value =Integer.parseInt(request.getParameter("hour_input"));
    int minute_value = Integer.parseInt(request.getParameter("minute_input"));
    String content_value = request.getParameter("content_input");
    int key_value = Integer.parseInt(request.getParameter("key_input"));
    String day_value = request.getParameter("date_input");

    if(session_key_value!=session_value){
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }

    if("PM".equals(apm_value)){
        if(hour_value !=12){
            hour_value = hour_value + 12;
        }
    }
    else if("AM".equals(apm_value) && hour_value == 12){
        hour_value = 0;
    }

    String date_value = day_value + " " + hour_value + ":" + minute_value + ":00";

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");
    
    String sql = "UPDATE schedule SET date=?, content=? WHERE schedule_key=?"; 
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, date_value);
    query.setString(2, content_value);
    query.setInt(3, key_value);
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
