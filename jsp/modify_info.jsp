<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<%
    //session.getAttribute는 Object 자료형이기에 String으로 형변환 해줌
    Object key_value_ob = session.getAttribute("key_value");
    if(key_value_ob == null){
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }
    Object id_value_ob = session.getAttribute("id_value");
    Object pw_value_ob = session.getAttribute("pw_value");
    Object phone_value_ob = session.getAttribute("phone_value");
    Object name_value_ob = session.getAttribute("name_value");
    Object rank_value_ob = session.getAttribute("rank_value");
    Object department_value_ob = session.getAttribute("department_value");

    int key_value = Integer.parseInt(key_value_ob.toString());
    String id_value = String.valueOf(id_value_ob);
    String pw_value = String.valueOf(pw_value_ob);
    String phone_value = String.valueOf(phone_value_ob);
    String name_value = String.valueOf(name_value_ob);
    String rank_value = String.valueOf(rank_value_ob);
    String department_value = String.valueOf(department_value_ob);

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/week09/css/modify_info.css">
    <link rel="stylesheet" href="/week09/css/common.css">
</head>
<body>
    <header>
        <input type="button" id="logo" value="Schedular" onclick="location.href='/week09/jsp/main.jsp'">
    </header>
    <main>
        <div class="title_div">
            정보수정
        </div>
        <form action="/week09/jsp/modify_info_action.jsp" onsubmit="return check_event()">
            <div class="id_div input_wrapper_div">
                <div class="input_name_div">
                    아이디
                </div>
                <div class="input_div">
                    <input type="text" readonly id="id" name="id_value"> <!-- onchange : 값에서 딱 뗐을 때 -->
                </div>
            </div>

            <div class="pw_div input_wrapper_div">
                <div class="input_name_div">
                    비밀번호
                </div>
                <div class="input_div">
                    <input type="password" id="pw" name="pw_value">
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
                    <input type="text" id="phone" name="phone_value">
                </div>
            </div>

            <div class="rank_div input_wrapper_div">
                <div class="input_name_div">
                    직급
                </div>
                <div class="radio_div">
                    <label for="member">팀원</label><input type="radio" id="member" name="rank_value" value="팀원">
                    <label for="leader">팀장</label><input type="radio" id="leader" name="rank_value" value="팀장">
                </div>
            </div>

            <div class="depart_div input_wrapper_div">
                <div class="input_name_div">
                    부서명
                </div>
                <div class="radio_div">
                    <label for="develop">개발팀</label> <input type="radio" id="develop" name="department_value" value="개발팀">
                    <label for="design">디자인팀</label><input type="radio" id="design" name="department_value" value="디자인팀">
                </div>
            </div>
            <input type="hidden" name="session_input" value="<%=key_value%>">
            <div class="submit_btn_div">
                <input type="submit" value="수정하기" id="sign_up" onclick="modify_info()">
                <input type="button" value="탈퇴하기" id="withdraw" onclick="location.href='/week09/jsp/resign_action.jsp'">
                <input type="button" value="취소" id="cancel" onclick="location.href='/week09/jsp/main.jsp'">
            </div>
        </form>
    </main>
    <footer>
        <input type="button" id="back_page" value="BACK" onclick="history.back()">
    </footer>
    <script>
        function check_event(){
            var pw = document.getElementById("pw").value
            var pw_check = document.getElementById("pw_check").value
            var name = document.getElementById("name").value
            var phone = document.getElementById("phone").value

            var pw_pattern = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,30}$/
            var name_pattern = /^[가-힣]{2,5}$/
            var phone_pattern = /^01[0179][0-9]{7,8}$/

            if(pw==="" &&pw_check === ""){
                document.getElementById("pw").value = '<%=pw_value%>'
            }else{
                if(!pw_pattern.test(pw)){
                    alert("비밀번호를 제대로 입력해 주세요")
                    return false
                }
                if(pw_check === "" || pw != pw_check){
                    alert("비밀번호를 확인해 주세요")
                }
            }

            if(name==="" || !name_pattern.test(name)){
                alert("이름을 제대로 입력해 주세요")
                return false
            }
            if(phone==="" || !phone_pattern.test(phone)){
                alert("전화번호를 제대로 입력해 주세요")
                return false
            }
        }
        document.getElementById("id").value='<%=id_value%>'
        document.getElementById("name").value='<%=name_value%>'
        document.getElementById("phone").value='<%=phone_value%>'
        if('<%=rank_value%>'==="팀원"){
            document.getElementById("member").checked = true
        }
        else if('<%=rank_value%>'==="팀장"){
            document.getElementById("leader").checked = true
        }
        if('<%=department_value%>'==="개발팀"){
            document.getElementById("develop").checked = true
        }
        else if('<%=department_value%>'==="디자인팀"){
            document.getElementById("design").checked = true
        }
    </script>
</body>
</html>