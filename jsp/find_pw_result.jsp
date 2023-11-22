<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    String name_value = request.getParameter("name_value");
    String id_value = request.getParameter("id_value");
    String phone_value = request.getParameter("phone_value");
    String pw_value ="";
    int check=0;

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

    String sql = "SELECT * FROM user WHERE name= ? AND id= ? AND phone= ?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, name_value);
    query.setString(2, id_value);
    query.setString(3, phone_value);
    ResultSet result = query.executeQuery();
    if(result.next()){
        pw_value = result.getString("pw");
        check=1;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/week09/css/find_pw_action.css">
    <link rel="stylesheet" href="/week09/css/common.css">
    <script>
        if(<%=check%>==0){
            alert("입력한 정보로 가입된 계정은 없습니다.")
            history.back()
        }
    </script>
</head>
<body>
    <main>
        <h1>비밀번호 찾기 결과</h1>
        <h3 id="result">입력한 정보로 조회된 비밀번호는 <%=pw_value%>입니다.</h3>
        <div id="button_div">
            <input type="button" value="로그인" id="log_in" onclick="location.href='/week09/jsp/log_in.jsp'">
            <input type="button" value="다시 찾기" id="refind" onclick="location.href='/week09/jsp/find_pw.jsp'">
        </div>
    </main>
</body>
</html>