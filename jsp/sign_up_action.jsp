<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.regex.Pattern" %>

<%
    request.setCharacterEncoding("utf-8");

    String id_value = request.getParameter("id_value");
    String pw_value = request.getParameter("pw_value");
    String name_value = request.getParameter("name_value");
    String phone_value = request.getParameter("phone_value");
    String rank_value = request.getParameter("rank_value");
    String department_value = request.getParameter("department_value");

    Pattern id_pattern = Pattern.compile("^[a-zA-Z0-9]{6,20}$");
    Pattern pw_pattern = Pattern.compile("^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,30}$");
    Pattern name_pattern = Pattern.compile("^[가-힣]{2,5}$");
    Pattern phone_pattern = Pattern.compile("^01[0179][0-9]{7,8}$");
    if(!id_pattern.matcher(id_value).matches() || !pw_pattern.matcher(pw_value).matches() || !name_pattern.matcher(name_value).matches() || !phone_pattern.matcher(phone_value).matches() || (!"팀원".equals(rank_value)&&!"팀장".equals(rank_value)) || (!"디자인팀".equals(department_value)&&!"개발팀".equals(department_value))){
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }
    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");
    
        String sql = "INSERT INTO user (id,pw,name,phone,rank,department) VALUES (?,?,?,?,?,?)";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, id_value);
        query.setString(2, pw_value);
        query.setString(3, name_value);
        query.setString(4, phone_value);
        query.setString(5, rank_value);
        query.setString(6, department_value);
        query.executeUpdate();
    } catch (Exception e){
        e.printStackTrace();
        return;
    }
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        alert("회원가입에 성공했습니다.")
        location.href="/week09/jsp/log_in.jsp"
    </script>
</body>