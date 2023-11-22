<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/week09/css/find_id.css">
    <link rel="stylesheet" href="/week09/css/common.css">
    <script>
        function check_event(){
            var name = document.getElementById("name").value
            var phone = document.getElementById("phone").value
    
            var name_pattern = /^[가-힣]{2,5}$/
            var phone_pattern = /^01[0179][0-9]{7,8}$/
            
            if(name.trim()==="" || !name_pattern.test(name)){
                alert("이름을 제대로 입력해 주세요")
                return false
            }
            if(phone.trim()==="" || !phone_pattern.test(phone)){
                alert("전화번호를 제대로 입력해 주세요")
                return false
            }
        }
    </script>
</head>
<body>
    <main>
        <h1>아이디 찾기</h1>
        <form action="/week09/jsp/find_id_result.jsp" onsubmit="return check_event()">
            <input type="text" id="name" class="find_id_txt div" name="name_value" placeholder="이름을 입력해주세요">
            <input type="text" id="phone" class="find_id_txt div" name="phone_value" placeholder="전화번호를 입력해주세요">
            <input type="submit" id="find_btn" class="div" value="찾기">
        </form>
        <div id="bottom">
            <input type="button" class="button" id="log_in_btn" value="로그인" onclick="location.href='/week09/jsp/log_in.jsp'"> |
            <input type="button" class="button" id="find_pw_btn" value="비밀번호찾기" onclick="location.href='/week09/jsp/find_pw.jsp'">
        </div>
    </main>
</body>
</html>