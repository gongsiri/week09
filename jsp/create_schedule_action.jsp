<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    Object key_value_ob = session.getAttribute("key_value");
    int key_value = Integer.parseInt(key_value_ob.toString());
    String apm_value = request.getParameter("apm_value");
    int hour_value = Integer.parseInt(request.getParameter("hour_value"));
    int minute_value = Integer.parseInt(request.getParameter("minute_value"));
    int year_value = Integer.parseInt(request.getParameter("year_value"));
    int month_value = Integer.parseInt(request.getParameter("month_value"));
    int day_value = Integer.parseInt(request.getParameter("day_value"));
    String content_value = request.getParameter("content_value");

    if("PM".equals(apm_value)){
        if(hour_value !=12){
            hour_value = hour_value + 12;
        }
    }
    else if("AM".equals(apm_value) && hour_value == 12){
        hour_value = 0;
    }
        

    String date_value = year_value + "-" + month_value + "-" + day_value + " " + hour_value + ":" + minute_value + ":00";
    
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
       alert("글쓰기 완료")
       console.log('<%=hour_value%>')
    </script>

</body>
