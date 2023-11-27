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
    <link rel="stylesheet" href="/week09/css/sign_up.css">
    <link rel="stylesheet" href="/week09/css/common.css">
    <script>
        function check_event(){
            var id = document.getElementById("id").value
            var pw = document.getElementById("pw").value
            var pw_check = document.getElementById("pw_check").value
            var name = document.getElementById("name").value
            var phone = document.getElementById("phone").value
    
            var id_pattern = /^[a-zA-Z0-9]{6,20}$/
            var pw_pattern = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,30}$/
            var name_pattern = /^[가-힣]{2,5}$/
            var phone_pattern = /^01[0179][0-9]{7,8}$/
    
            if(id.trim()==="" || !id_pattern.test(id)){
                alert("아이디를 제대로 입력해 주세요")
                return false
            }
            if(document.getElementById("id_duplication_check_btn").style.display!="none"){
                alert("아이디 중복확인을 진행해주십시오")
                return false
            }
            if(pw.trim()==="" || !pw_pattern.test(pw)){
                alert("비밀번호를 제대로 입력해 주세요")
                return false
            }
            if(pw_check.trim()==="" || pw!=pw_check){
                alert("비밀번호를 확인해 주세요")
                return false
            }
            if(name.trim()==="" || !name_pattern.test(name)){
                alert("이름을 제대로 입력해 주세요")
                return false
            }
            if(phone.trim()==="" || !phone_pattern.test(phone)){
                alert("전화번호를 제대로 입력해 주세요")
                return false
            }
        }
    
        function id_duplication_check_event(){
            var id_pattern = /^[a-zA-Z0-9]{6,20}$/
            var id= document.getElementById("id").value
            if(id.trim()==="" || !id_pattern.test(id)){
                alert("아이디를 제대로 입력해 주세요")
                return false
            }
            indow.open("/week09/jsp/id_duplication_check_action.jsp?id_value="+ id,"width=400","height=350")

        }
    </script>
</head>
<body>
    <main>
        <div class="title_div">
            회원가입
        </div>
        <form action="/week09/jsp/sign_up_action.jsp" onsubmit="return check_event()">
            <div class="id_div input_wrapper_div">
                <div class="input_name_div">
                    아이디
                </div>
                <div class="input_div">
                    <input type="text" id="id" name="id_value"> <!-- onchange : 값에서 딱 뗐을 때 -->
                    <button type="button" id="id_duplication_check_btn" onclick="id_duplication_check_event()">중복확인</button>
                </div>
            </div>

            <div class="pw_div input_wrapper_div">
                <div class="input_name_div">
                    비밀번호
                </div>
                <div class="input_div">
                    <input type="password" placeholder="영문자,숫자,특수문자 포함 6~30자" id="pw" name="pw_value">
                </div>
            </div>

            <div class="pw_check_div input_wrapper_div">
                <div class="input_name_div">
                    비밀번호 확인
                </div>
                <div class="input_div">
                    <input type="password" id="pw_check">
                </div>
            </div>

            <div class="name_div input_wrapper_div">
                <div class="input_name_div">
                    이름
                </div>
                <div class="input_div">
                    <input type="text" id="name" name="name_value">
                </div>
            </div>

            <div class="phone_div input_wrapper_div">
                <div class="input_name_div">
                    전화번호
                </div>
                <div class="input_div">
                    <input type="text" placeholder="(-) 없이 입력" id="phone" name="phone_value">
                </div>
            </div>

            <div class="rank_div input_wrapper_div">
                <div class="input_name_div">
                    직급
                </div>
                <div class="radio_div">
                    <label for="member">팀원</label><input type="radio" id="member" name="rank_value" value="팀원" checked="checked">
                    <label for="leader">팀장</label><input type="radio" id="leader" name="rank_value" value="팀장">
                </div>
            </div>

            <div class="depart_div input_wrapper_div">
                <div class="input_name_div">
                    부서명
                </div>
                <div class="radio_div">
                    <label for="develop">개발팀</label> <input type="radio" id="develop" name="department_value" value="개발팀" checked="checked">
                    <label for="design">디자인팀</label><input type="radio" id="design" name="department_value" value="디자인팀">
                </div>
            </div>

            <div class="submit_btn_div">
                <input type="submit" value="가입하기" id="sign_up">
                <input type="button" value="가입취소" id="cancel" onclick="location.href='/week09/jsp/log_in.jsp'">
            </div>
        </form>
    </main>
</body>
</html>