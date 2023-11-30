<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="kr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/week09/css/log_in.css">
    <link rel="stylesheet" href="/week09/css/common.css">
</head>
<body>
    <main>
        <h1>Welcome To Schedular</h1>
        <h2>로그인 해주세요</h2>
        <form action="/week09/jsp/log_in_action.jsp" onsubmit="return check_event()">
            <input type="text" class="log_in_txt div" placeholder="아이디를 입력해주세요" id="id" name="id_value">
            <input type="password" class="log_in_txt div" placeholder="비밀번호를 입력해주세요" id="pw" name="pw_value">
            <input type="submit" class="div" id="log_in_btn" value="로그인">
        </form>
        <div id="log_in_bottom_div">
            <input type="button" class="log_in_bottom" value="회원가입" onclick="location.href='/week09/jsp/sign_up.jsp'"> |
            <input type="button" class="log_in_bottom" value="아이디 찾기" onclick="location.href='/week09/jsp/find_id.jsp'"> |
            <input type="button" class="log_in_bottom" value="비밀번호 찾기" onclick="location.href='/week09/jsp/find_pw.jsp'"> 
        </div>
    </main>
    <footer>
        <input type="button" id="back_page" value="BACK" onclick="history.back()">
    </footer>
    <script>
        function check_event(){
            var id = document.getElementById("id").value
            var pw = document.getElementById("pw").value
    
            var id_pattern = /^[a-zA-Z0-9]{6,20}$/
            var pw_pattern = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,30}$/
            
            if(!id_pattern.test(id)){
                alert("아이디를 제대로 입력해 주세요")
                return false
            }
            if(!pw_pattern.test(pw)){
                alert("비밀번호를 제대로 입력해 주세요")
                return false
            }
        }
    </script>
</body>
</html>