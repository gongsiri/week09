<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<%
    //session.getAttribute는 Object 자료형이기에 String으로 형변환 해줌
    Object id_value_ob = session.getAttribute("id_value");
    Object key_value_ob = session.getAttribute("key_value");
    Object phone_value_ob = session.getAttribute("phone_value");
    Object name_value_ob = session.getAttribute("name_value");
    Object rank_value_ob = session.getAttribute("rank_value");
    Object department_value_ob = session.getAttribute("department_value");

    String id_value = String.valueOf(id_value_ob);
    int key_value = Integer.parseInt(key_value_ob.toString());
    String phone_value = String.valueOf(phone_value_ob);
    String name_value = String.valueOf(name_value_ob);
    String rank_value = String.valueOf(rank_value_ob);
    String department_value = String.valueOf(department_value_ob);

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

    String sql = "SELECT * FROM user WHERE department=? AND id !=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, department_value);
    query.setString(2, id_value);
    ResultSet result = query.executeQuery();

    ArrayList<ArrayList<String>> member_list = new ArrayList<ArrayList<String>>();

    while(result.next()){ 
        String member_id = result.getString("id");
        String member_name = result.getString("name");

        ArrayList<String> member_info = new ArrayList<String>();
        member_info.add("\""+member_id+"\"");
        member_info.add("\""+member_name+"\"");
        member_list.add(member_info);
    }

    String sql2 = "SELECT DATE_FORMAT(date, '%Y-%m-%d') AS formatted_date, COUNT(*) AS schedule_count FROM schedule WHERE user_key = ? GROUP BY formatted_date";
    PreparedStatement query2 = connect.prepareStatement(sql2);
    query2.setInt(1, key_value);
    ResultSet result2 = query2.executeQuery();

    ArrayList<ArrayList<String>> schedule_list = new ArrayList<ArrayList<String>>();

    while(result2.next()){
        String date = result2.getString("formatted_date");
        int schedule_count = result2.getInt("schedule_count");

        ArrayList<String> schedule_info = new ArrayList<String>();
        schedule_info.add("\""+date+"\"");
        schedule_info.add(String.valueOf(schedule_count));
        schedule_list.add(schedule_info);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/week09/css/main.css">
    <link rel="stylesheet" href="/week09/css/common.css">
</head>
<body>
    <div id="dark_background"></div>
    <header>
        <input type="button" id="logo" value="Schedular" onclick="location.href='main.jsp'">
        <button type="button" class="menu" onclick="show_menu_event()">
            <svg height="24" viewBox="0 0 24 24" width="24" focusable="false" style="pointer-events: none; display: block; width: 100%; height: 100%;"><path d="M21 6H3V5h18v1zm0 5H3v1h18v-1zm0 6H3v1h18v-1z"></path></svg>
        </button>
    </header>
    <main>
        <div id="top">
            <div id="member_info"> <!--팀원 일정일 경우-->
                <div id="member_name_div"></div>
                <div id="member_id_div"></div>
            </div>
            <div id="year_div">
                <input type="button" id="back" value="<" onclick="prev_year_event()">
                <p id="year"></p>
                <input type="button" id="next" value=">" onclick="next_year_event()">
            </div>
        </div>
        <div id="month_div"></div> <!--월 버튼-->
        <table id="calender"></table> <!--달력-->
        <div id="modal_overlay"> <!--모달창 외부-->
            <div id="modal"> <!--모달창 내부-->
                <div id="date_div"> <!--날짜 출력-->
                    <div id="date">
                        <div id="modal_year"></div>년
                        <div id="modal_month"></div>월
                        <div id="modal_day"></div>일
                    </div>
                    <button type="button" id="exit" onclick="close_modal_event()">X</button>
                </div>
                <div class="details_div_container"> <!--일정 컨테이너--></div>
                <form action="/week09/jsp/create_schedule_action.jsp" onsubmit="return check_event()" id="input_date_div"> <!--일정 추가 영역-->
                    <input type="hidden" name="year_value" id=year_value>
                    <input type="hidden" name="month_value" id=month_value>
                    <input type="hidden" name="day_value" id=day_value>
                    <input type="hidden" name="apm_value" class="apm_value">
                    <input type="hidden" name="hour_value" class="hour_value">
                    <input type="hidden" name="minute_value" class="minute_value">
                    <div id="input_date_top">
                        <div class="time"> <!--시간-->
                            <button type="button" class="apm" onclick="apm_change_event(this)">AM</button>
                            <div class="hour">1</div>
                            <div class="hour_button_div">
                                <button type="button" class="hour_plus_btn" onclick="hour_plus_event(this,false)">+</button>
                                <button type="button" class="hour_minus_btn" onclick="hour_minus_event(this,false)">-</button>
                            </div>
                            <div class="minute">00</div>
                            <div class="minute_button_div">
                                <button type="button" class="minute_plus_btn" onclick="minute_plus_event(this,false)">+</button>
                                <button type="button" class="minute_minus_btn" onclick="minute_minus_event(this,false)">-</button>
                            </div>
                        </div>
                        <p id="alert_content">내용을 입력해 주세요</p> <!--경고 문구-->
                        <input type="submit" id="add" value="추가">
                    </div>
                    <input type="text" id="input_date" placeholder="내용을 입력해 주세요." name="content_value"> <!--일정 내용-->
                </form>
            </div>
        </div>

        <div id="hidden_menu"> <!--오른쪽 메뉴-->
            <div id="hidden_menu_top">
                <button type="button" class="menu" onclick="show_menu_event()" >
                    <svg height="24" viewBox="0 0 24 24" width="24" focusable="false" style="pointer-events: none; display: block; width: 100%; height: 100%;"><path d="M21 6H3V5h18v1zm0 5H3v1h18v-1zm0 6H3v1h18v-1z"></path></svg>
                </button>
            </div>
            <div id="name_div"> <!--정보-->
                이름
                <div id="name"></div>
            </div>
            <div id="id_div">
                아이디
                <div id="id"></div>
            </div>
            <div id="phone_div">
                전화번호
                <div id="phone"></div>
            </div>
            <div id="department_div">
                부서
                <div id="department"></div>
            </div>
            <div id="rank_div">
                직급
                <div id="rank"></div>
            </div>
            <div id="button_div">
                <input type="button" id="modify" value="수정" onclick="location.href='/week09/jsp/modify_info.jsp'">
                <input type="button" id="log_out" value="로그아웃" onclick="location.href='/week09/jsp/log_out_action.jsp'">
            </div>
            <div id="border_line"></div>
            <div id="member_list">
                <p>내 팀원 목록</p>
            </div>
        </div>
    </main>
    <script>
        var today = new Date()
        var year = today.getFullYear()
        var month = today.getMonth() + 1
        var day = today.getDate()
    
        window.onload = function () {
            make_month()
            make_schedule()
            document.getElementById("year").innerHTML = year
            var btn = document.getElementById("month" + month)
            select_month_event(btn)
            if('<%=rank_value%>' === "팀장"){
                document.getElementById("member_list").style.display='block'
                make_me()
                make_member_list()
            }
            else if('<%=rank_value%>' === "팀원"){
                document.getElementById("member_list").style.display='none'
            }
            is_schedule()
        }

        function is_schedule(){
            var schedule_list = <%=schedule_list%>
            for(var i=0; i<schedule_list.length; i++){
                var schedule_date = new Date(schedule_list[i][0])
                var schedule_day = schedule_date.getDate()
                var schedule_month = schedule_date.getMonth()+1
                var schedule_year = schedule_date.getFullYear()
                
                console.log(schedule_day)
                console.log(schedule_month)
                console.log(schedule_year)

                var schedule_count = schedule_list[i][1]
                console.log(schedule_year+"-"+schedule_month +"-"+schedule_day)
                var day_element = document.getElementById(schedule_year+"-"+schedule_month +"-"+schedule_day)

                if (day_element) {
                    var existing_circle = day_element.getElementsByClassName("circle")
                    if (existing_circle.length > 0) {
                        if(schedule_count >= 10){
                            existing_circle[0].innerHTML = "9+"
                        }
                        else{
                            existing_circle[0].innerHTML = schedule_count
                        }
                    } else {
                        var circle_div = document.createElement("div");
                        circle_div.className = "circle";
                        if (schedule_count >= 10) {
                            circle_div.innerHTML = '9+';
                        } else {
                            circle_div.innerHTML = schedule_count;
                        }
                        day_element.appendChild(circle_div);
            }
        }  
            }
        }
        function make_schedule(year,month,day){
            var details_div_container = document.getElementsByClassName("details_div_container")[0]
            details_div_container.className="details_div_container"

            for(var i=0; i<3; i++){
                var details_div = document.createElement("div")
                details_div.className="details_div"

                var details_time = document.createElement("div")
                details_time.className="details_time"
                details_time.innerHTML = "AM 10:00"

                var modify_details_time = document.createElement("div")
                modify_details_time.className="modify_details_time"

                var apm = document.createElement("button")
                apm.className="apm"
                apm.type="button"
                apm.innerHTML="AM"
                apm.onclick=function(){
                    apm_change_event(this)
                }

                var hour = document.createElement("div")
                hour.className="hour"
                hour.innerHTML="1"

                var hour_button_div = document.createElement("div")
                hour_button_div.className="hour_button_div"

                var hour_plus_btn = document.createElement("button")
                hour_plus_btn.className="hour_plus_btn"
                hour_plus_btn.type="button"
                hour_plus_btn.innerHTML="+"
                hour_plus_btn.onclick=function(){
                    hour_plus_event(this,true)
                }

                var hour_minus_btn = document.createElement("button")
                hour_minus_btn.className="hour_minus_btn"
                hour_minus_btn.type="button"
                hour_minus_btn.innerHTML="-"
                hour_minus_btn.onclick=function(){
                    hour_minus_event(this,true)
                }

                var minute = document.createElement("div")
                minute.className="minute"
                minute.innerHTML="00"

                var minute_button_div = document.createElement("div")
                minute_button_div.className="minute_button_div"

                var minute_plus_btn = document.createElement("button")
                minute_plus_btn.className="minute_plus_btn"
                minute_plus_btn.type="button"
                minute_plus_btn.innerHTML="+"
                minute_plus_btn.onclick=function(){
                    minute_plus_event(this,true)
                }

                var minute_minus_btn = document.createElement("button")
                minute_minus_btn.className="minute_minus_btn"
                minute_minus_btn.type="button"
                minute_minus_btn.innerHTML="-"
                minute_minus_btn.onclick=function(){
                    minute_minus_event(this,true)
                }

                var details = document.createElement("div")
                details.className="details"

                var details_content = document.createElement("div")
                details_content.className="details_content"
                details_content.innerHTML="미용실 가기"

                var modify_details_content = document.createElement("input")
                modify_details_content.className="modify_details_content"
                modify_details_content.placeholder="미용실 가기"

                var button_div = document.createElement("div")
                button_div.className="button_div"

                var modify_details = document.createElement("button")
                modify_details.className="modify_details"
                modify_details.type="button"
                modify_details.innerHTML="수정"
                modify_details.onclick=function(){
                    modify_details_event(this)
                }

                var delete_details = document.createElement("button")
                delete_details.className="delete_details"
                delete_details.innerHTML="삭제"

                var modify_details_submit = document.createElement("button")
                modify_details_submit.className="modify_details_submit"
                modify_details_submit.innerHTML="완료"

                var modify_details_cancel = document.createElement("button")
                modify_details_cancel.className="modify_details_cancel"
                modify_details_cancel.innerHTML="취소"
                modify_details_cancel.onclick=function(){
                    modify_details_cancel_event(this)
                }

                button_div.appendChild(modify_details)
                button_div.appendChild(delete_details)
                button_div.appendChild(modify_details_submit)
                button_div.appendChild(modify_details_cancel)

                details.appendChild(details_content)
                details.appendChild(modify_details_content)
                details.appendChild(button_div)

                minute_button_div.appendChild(minute_plus_btn)
                minute_button_div.appendChild(minute_minus_btn)

                hour_button_div.appendChild(hour_plus_btn)
                hour_button_div.appendChild(hour_minus_btn)

                modify_details_time.appendChild(apm)
                modify_details_time.appendChild(hour)
                modify_details_time.appendChild(hour_button_div)
                modify_details_time.appendChild(minute)
                modify_details_time.appendChild(minute_button_div)

                details_div.appendChild(details_time)
                details_div.appendChild(modify_details_time)
                details_div.appendChild(details)

                details_div_container.appendChild(details_div)
            }   
        }
        function make_me(){
            var id = '<%=id_value%>'
            var name = '<%=name_value%>'
            var button = document.createElement("button")
            button.type="button"
            button.className="member"
            button.onclick=function(){
                select_me_event()
            }
            var name_div = document.createElement("div")
            name_div.className="member_name"
            name_div.innerHTML=name

            var id_div = document.createElement("div")
            id_div.className="member_id"
            id_div.innerHTML=id+" (나)"

            button.appendChild(name_div)
            button.appendChild(id_div)

            document.getElementById("member_list").appendChild(button)
        }

        function make_member_list(){
            var member_list = <%=member_list%>

            for(var i=0; i<member_list.length; i++){
                var button = document.createElement("button")
                button.type="button"
                button.className="member"
                button.onclick=function(){
                    select_member_event(this)
                }
                var member_name = document.createElement("div")
                member_name.className="member_name"
                member_name.innerHTML=member_list[i][1]

                var member_id = document.createElement("div")
                member_id.className="member_id"
                member_id.innerHTML=member_list[i][0]
                
                button.appendChild(member_name)
                button.appendChild(member_id)

                document.getElementById("member_list").appendChild(button)
            }
        }


        function show_menu_event() {
            var hidden_menu = document.getElementById("hidden_menu")
            var dark_background = document.getElementById("dark_background")
    
            if (dark_background.style.display != 'block') {
                hidden_menu.style.right = '0'
                dark_background.style.display = 'block'
            }
            else {
                hidden_menu.style.right = '-240px'
                dark_background.style.display = 'none'
            }
        }
        function select_month_event(selected) {
            month = selected.value
            var button = document.getElementsByClassName("month")
            for (var i = 0; i < 12; i++) {
                button[i].style.backgroundColor = 'white'
            }
            selected.style.backgroundColor = '#E16A9D'
            delete_calender()
            make_calender(month)
        }
    
        function prev_year_event() {
            year = year - 1
            document.getElementById("year").innerHTML = year
            delete_calender()
            make_calender(month)
        }
    
        function next_year_event() {
            year = year + 1
            document.getElementById("year").innerHTML = year
            delete_calender()
            make_calender(month)
        }
    
        function open_modal_event(id) {
            var modify_details = document.getElementsByClassName("modify_details")
            var delete_details = document.getElementsByClassName("delete_details")
            var input_date_div = document.getElementById("input_date_div")
            var member_name_div = document.getElementById("member_name_div").innerHTML
    
            var part = id.split("-")
            var year = parseInt(part[0]);
            var month = parseInt(part[1]);
            var day = parseInt(part[2]);

            make_schedule(year,month,day)

            document.getElementById("input_date").value = "";
            document.getElementById("alert_content").style.display = "none";
            for(var i=0; i<4; i++){
                document.getElementsByClassName("hour")[i].innerHTML="1";
                document.getElementsByClassName("minute")[i].innerHTML="00";
                document.getElementsByClassName("apm")[i].innerHTML="AM"
            }
            document.getElementsByClassName("hour_value")[0].value = "1";
            document.getElementsByClassName("minute_value")[0].value = "00";
            document.getElementsByClassName("apm_value")[0].value = "AM";
            for(var i=0; i<3; i++){
                document.getElementsByClassName("modify_details_content")[i].value=""
                modify_details_cancel_event(document.getElementsByClassName("details_div")[i])
            }
            document.getElementById("modal_overlay").style.display = "block"
            document.getElementById("modal").style.display = "block"
            document.getElementById("modal_year").innerHTML = year
            document.getElementById("modal_month").innerHTML = month
            document.getElementById("modal_day").innerHTML = day
            document.getElementById("year_value").value = year
            document.getElementById("month_value").value = month
            document.getElementById("day_value").value = day
    
            if(member_name_div!=""){ //팀장이 팀원의 목록을 보는 경우
                for(var i=0; i<3; i++){
                    modify_details[i].style.display='none'
                    delete_details[i].style.display='none'
                }
                input_date_div.style.display='none'
            }
            console.log(id)
        }
    
        function close_modal_event() {
            document.getElementById("modal_overlay").style.display = "none"
            document.getElementById("modal").style.display = "none"
        }
    
        function hour_plus_event(selected,ismodify) {
            if(ismodify){
                var hour_div = selected.closest('.modify_details_time')
            }
            else{
                var hour_div = selected.closest('#input_date_div')
            }
            console.log(hour_div)
            var hour_element = hour_div.getElementsByClassName("hour")[0].innerHTML
            var hour = parseInt(hour_element, 10)
            console.log(hour)
            hour += 1
            if (hour == 13) {
                hour = 1
            }
            hour_div.getElementsByClassName("hour")[0].innerHTML = hour
            hour_div.getElementsByClassName("hour_value")[0].value= hour
        }
    
        function hour_minus_event(selected,ismodify) {
            if(ismodify){
                var hour_div = selected.closest('.modify_details_time')
            }
            else{
                var hour_div = selected.closest('#input_date_div')
            }
            var hour_element = hour_div.getElementsByClassName("hour")[0].innerHTML
            var hour = parseInt(hour_element, 10)
            hour -= 1
            if (hour == 0) {
                hour = 12
            }
            hour_div.getElementsByClassName("hour")[0].innerHTML = hour
            hour_div.getElementsByClassName("hour_value")[0].value= hour
        }
    
        function minute_plus_event(selected,ismodify) {
            console.log(selected)
            if(ismodify){
                var minute_div = selected.closest('.modify_details_time')
            }
            else{
                var minute_div = selected.closest('#input_date_div')
            }
            console.log(minute_div)
            var minute_element = minute_div.getElementsByClassName("minute")[0].innerHTML
            var minute = parseInt(minute_element, 10) + 1
            if (minute == 60) {
                minute = 0
            }
            minute = (minute < 10 ? '0' : '') + minute
            minute_div.getElementsByClassName("minute")[0].innerHTML = minute
            minute_div.getElementsByClassName("minute_value")[0].value= minute
        }
    
        function minute_minus_event(selected,ismodify) {
            if(ismodify){
                var minute_div = selected.closest('.modify_details_time')
            }
            else{
                var minute_div = selected.closest('#input_date_div')
            }
            var minute_element = minute_div.getElementsByClassName("minute")[0].innerHTML
            var minute = parseInt(minute_element, 10)
            if (minute == 0) {
                minute = 59
            }
            else {
                minute -= 1
            }
            minute = (minute < 10 ? '0' : '') + minute
            minute_div.getElementsByClassName("minute")[0].innerHTML = minute
            minute_div.getElementsByClassName("minute_value")[0].value= minute
        }
    
        function apm_change_event(selected) {
            console.log(selected)
            console.log(selected.closest("#input_date_div"))
            var input_date_div = selected.closest("#input_date_div")
            if (selected.innerHTML == "AM") {
                selected.innerHTML = "PM"
                input_date_div.getElementsByClassName("apm_value")[0].value="PM"
            }
            else{
                selected.innerHTML = "AM"
                input_date_div.getElementsByClassName("apm_value")[0].value="AM"
            }
        }
    
        function modify_details_event(selected) {
            var details_div = selected.closest('.details_div')
            var details_time = details_div.getElementsByClassName("details_time")[0]
            var details_content = details_div.getElementsByClassName("details_content")[0]
            var modify_details_time = details_div.getElementsByClassName("modify_details_time")[0]
            var modify_details_content = details_div.getElementsByClassName("modify_details_content")[0]
            var modify_details = details_div.getElementsByClassName("modify_details")[0]
            var delete_details = details_div.getElementsByClassName("delete_details")[0]
            var modify_details_submit = details_div.getElementsByClassName("modify_details_submit")[0]
            var modify_details_cancel = details_div.getElementsByClassName("modify_details_cancel")[0]
    
            details_time.style.display='none'
            details_content.style.display='none'
            modify_details.style.display='none'
            delete_details.style.display='none'
            
            modify_details_time.style.display='flex'
            modify_details_content.style.display='flex'
            modify_details_submit.style.display='inline-block'
            modify_details_cancel.style.display='inline-block'
        }
    
        function modify_details_cancel_event(selected){
            var details_div = selected.closest('.details_div')
            var details_time = details_div.getElementsByClassName("details_time")[0]
            var details_content = details_div.getElementsByClassName("details_content")[0]
            var modify_details_time = details_div.getElementsByClassName("modify_details_time")[0]
            var modify_details_content = details_div.getElementsByClassName("modify_details_content")[0]
            var modify_details = details_div.getElementsByClassName("modify_details")[0]
            var delete_details = details_div.getElementsByClassName("delete_details")[0]
            var modify_details_submit = details_div.getElementsByClassName("modify_details_submit")[0]
            var modify_details_cancel = details_div.getElementsByClassName("modify_details_cancel")[0]
    
            details_time.style.display='flex'
            details_content.style.display='flex'
            modify_details.style.display='inline-block'
            delete_details.style.display='inline-block'
    
    
            modify_details_time.style.display='none'
            modify_details_content.style.display='none'
            modify_details_submit.style.display='none'
            modify_details_cancel.style.display='none'
        }
    
        function select_member_event(selected){
            var member_name = selected.getElementsByClassName('member_name')[0].innerHTML
            var member_id = selected.getElementsByClassName('member_id')[0].innerHTML
    
            console.log(member_name)
            console.log(member_id)
    
            var member_info = document.getElementById("member_info")
            var member_name_div=document.getElementById("member_name_div")
            var member_id_div=document.getElementById("member_id_div")
            var hidden_menu = document.getElementById("hidden_menu")
            var dark_background = document.getElementById("dark_background")
    
            member_info.style.display='flex'
            member_name_div.innerHTML= member_name
            member_id_div.innerHTML= member_id
            hidden_menu.style.right = '-240px'
            dark_background.style.display = 'none'
        }
    
        function select_me_event(){
            var hidden_menu = document.getElementById("hidden_menu")
            var dark_background = document.getElementById("dark_background")
            var member_info = document.getElementById("member_info")
            var member_name_div = document.getElementById("member_name_div")
    
            hidden_menu.style.right = '-240px'
            dark_background.style.display = 'none'
            member_info.style.display='none'
            member_name_div.innerHTML=''
            console.log(member_name_div.innerHTML+"sid")
        }
    
        function check_event() {
            var input_date = document.getElementById("input_date").value
            if (input_date.trim() === "") {
                document.getElementById("alert_content").style.display = "block"
                return false
            }
            else {
                document.getElementById("alert_content").style.display = "none"
                return true
            }
        }
        
        function make_calender(selected) {
            var table = document.getElementById("calender")
            var year_cnt = 0
            var row_cnt = 0;
            if (selected == 1 || selected == 3 || selected == 5 || selected == 7 || selected == 8 || selected == 10 || selected == 12) {
                year_cnt = 31
                row_cnt = 5
            }
            else if (selected == 2) {
                year_cnt = 28
                row_cnt = 4
            }
            else {
                year_cnt = 30
                row_cnt = 5
            }
    
            for (var i = 0; i < row_cnt; i++) {
                var tr = document.createElement("tr")
                for (var j = 0; j < 7; j++) {
                    var td = document.createElement("td")
                    var month_day = i * 7 + j + 1
                    if (month_day <= year_cnt) {
                        var div = document.createElement("div")
                        div.classList.add("day_txt")
                        div.innerHTML = month_day
                        td.appendChild(div)
                    
                        td.id = year+"-"+month +"-"+month_day

                        td.onclick = function () {
                            open_modal_event(this.id)
                        }
                    }
                    tr.appendChild(td)
                }
                table.appendChild(tr)
            }
            is_schedule();
        }
    
        function make_month(){
            var month_div = document.getElementById("month_div")
            for(var i=1; i<13; i++){
                var button = document.createElement("input")
                button.type= "button"
                button.className = "month"
                button.id = "month"+i
                button.value = i
                button.onclick= function(){
                    select_month_event(this)
                }
                month_div.appendChild(button)
            }
        }
    
        function delete_calender() {
            var table = document.getElementById("calender")
            while (table.firstChild) {
                table.removeChild(table.firstChild)
            }
        }
        document.getElementById("name").innerHTML='<%=name_value%>'
        document.getElementById("id").innerHTML='<%=id_value%>'
        document.getElementById("phone").innerHTML='<%=phone_value%>'
        document.getElementById("rank").innerHTML='<%=rank_value%>'
        document.getElementById("department").innerHTML='<%=department_value%>'

    </script>
</body>