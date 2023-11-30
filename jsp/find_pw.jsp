<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/week09/css/find_pw.css">
    <link rel="stylesheet" href="/week09/css/common.css">
</head>
<body>
    <main>
        <h1>비밀번호 찾기</h1>
        <form action="/week09/jsp/find_pw_result.jsp" onsubmit="return check_event()">
            <input type="text" id="name" class="find_pw_txt div" name="name_value" placeholder="이름을 입력해주세요">
            <input type="text" id="id" class="find_pw_txt div" name="id_value" placeholder="아이디를 입력해주세요">
            <input type="text" id="phone" class="find_pw_txt div" name="phone_value" placeholder="전화번호를 입력해주세요">
            <input type="submit" id="find_btn" class="div" value="찾기">
        </form>
        <div id="bottom">
            <input type="button" class="button" id="log_in_btn" value="로그인" onclick="location.href='/week09/jsp/log_in.jsp'"> |
            <input type="button" class="button" id="find_id_btn" value="아이디 찾기" onclick="location.href='/week09/jsp/find_id.jsp'">
        </div>
    </main>
    <footer>
        <input type="button" id="back_page" value="BACK" onclick="history.back()">
    </footer>

    <script>
        function check_event(){
            var name = document.getElementById("name").value
            var phone = document.getElementById("phone").value
            var id = document.getElementById("id").value
    
            var name_pattern = /^[가-힣]{2,5}$/
            var phone_pattern = /^01[0179][0-9]{7,8}$/
            var id_pattern = /^[a-zA-Z0-9]{6,20}$/
            
            if(name.trim()==="" || !name_pattern.test(name)){
                alert("이름을 제대로 입력해 주세요")
                return false
            }
            if(id.trim()==="" || !id_pattern.test(id)){
                alert("아이디를 제대로 입력해 주세요")
                return false
            }
            if(phone.trim()==="" || !phone_pattern.test(phone)){
                alert("전화번호를 제대로 입력해 주세요")
                return false
            }
        }
    </script>
</body>
</html>