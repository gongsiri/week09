<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<%
    //session.getAttribute는 Object 자료형이기에 String으로 형변환 해줌
    String apm_value = request.getParameter("apm_input");
    int hour_value =Integer.parseInt(request.getParameter("hour_input"));
    int minute_value = Integer.parseInt(request.getParameter("minute_input"));
    String content_value = request.getParameter("modify_details_content");
    int key_value = Integer.parseInt(request.getParameter("key_input"));
    String day_value = request.getParameter("date_input");

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

    String sql = "DELETE FROM schedule WHERE schedule_key=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setInt(1, key_value);
    query.executeUpdate();

    String sql2 = "INSERT INTO SET schedule (date, content) VALUES (?, ?)"; 
    PreparedStatement query2 = connect.prepareStatement(sql2);
    query2.setString(1, date_value);
    query2.setString(2, content_value);
    query2.executeUpdate();

%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
       alert("수정 완료")
       location.href="/week09/jsp/main.jsp"
    </script>

</body>
