<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

// 일정 수정 jsp를 다른 사용자가 접근하는 것도 막아야 하나요??
<%
    Object key_value_ob = session.getAttribute("key_value");
    if(key_value_ob == null){
        response.sendRedirect("/week09/jsp/log_in.jsp");
    }
    Object id_value_ob = session.getAttribute("id_value"); 
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

    String member_name_input = ""; // 팀장의 권한으로 팀원 페이지를 볼 때 보여질 팀원의 이름
    String member_id_input = "";

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

    String sql = "SELECT * FROM user WHERE department=? AND id !=?"; // 현재 사용자의 부서에 속한 팀원들의 목록(나 제외)
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, department_value);
    query.setString(2, id_value);
    ResultSet result = query.executeQuery();

    ArrayList<ArrayList<String>> member_list = new ArrayList<ArrayList<String>>(); // 팀원들의 id, name, key 담아줌
    while(result.next()){ 
        String member_id = result.getString("id");
        String member_name = result.getString("name");
        int member_key = result.getInt("user_key");
        String member_department = result.getString("department");

        ArrayList<String> member_info = new ArrayList<String>();
        member_info.add("\""+member_id+"\"");
        member_info.add("\""+member_name+"\"");
        member_info.add("\""+member_key+"\"");
        member_info.add("\""+member_department+"\"");
        member_list.add(member_info);
    }

    if(request.getParameter("member_key") != null && "팀장".equals(rank_value)){  // 팀장의 권한으로 팀원 페이지를 볼 때 (아니라면 그냥 세션이 key_value가 됨)
        String member_department_input = request.getParameter("member_department_input");
        if(member_department_input.equals(department_value)){ // 같은부서일 때
            key_value = Integer.parseInt(request.getParameter("member_key")); // key_value를 팀원의 key로 바꿔줌 (session은 그대로)
            member_name_input = request.getParameter("member_name_input");
            member_id_input = request.getParameter("member_id_input");
        }
    }
    // 날짜별로 일정 개수 가져옴
    String sql2 = "SELECT DATE_FORMAT(date, '%Y-%m-%d') AS formatted_date, YEAR(date) as year, MONTH(date) as month, DAY(date) as day, COUNT(*) AS schedule_count FROM schedule WHERE user_key = ? GROUP BY formatted_date"; 
    PreparedStatement query2 = connect.prepareStatement(sql2);
    query2.setInt(1, key_value);
    ResultSet result2 = query2.executeQuery();

    ArrayList<ArrayList<String>> schedule_count_list = new ArrayList<ArrayList<String>>(); 

    while(result2.next()){
        String date = result2.getString("formatted_date");
        String year = result2.getString("year");
        String month = result2.getString("month");
        String day = result2.getString("day");
        int schedule_count = result2.getInt("schedule_count");
        
        ArrayList<String> schedule_count_info = new ArrayList<String>();
        schedule_count_info.add("\""+date+"\"");
        schedule_count_info.add(String.valueOf(schedule_count));
        schedule_count_info.add("\""+year+"\"");
        schedule_count_info.add("\""+month+"\"");
        schedule_count_info.add("\""+day+"\"");
        schedule_count_list.add(schedule_count_info);
    }

    // 날짜,시,분,내용,키 가져옴
    String sql3 = "SELECT DATE_FORMAT(date, '%Y-%m-%d') AS formatted_date, HOUR(date) AS hour, MINUTE(date) AS minute, content, schedule_key FROM schedule WHERE user_key =? ORDER BY date"; // 고치자 월 년 일 다 꺼내오자
    PreparedStatement query3 = connect.prepareStatement(sql3);
    query3.setInt(1,key_value);
    ResultSet result3 = query3.executeQuery();

    ArrayList<ArrayList<String>> schedule_list = new ArrayList<ArrayList<String>>();

    while(result3.next()){
        String formatted_date = result3.getString("formatted_date");
        String hour = result3.getString("hour");
        String minute = result3.getString("minute");
        String content = result3.getString("content");
        int schedule_key = result3.getInt("schedule_key");

        ArrayList<String> schedule_info = new ArrayList<String>();
        schedule_info.add("\""+formatted_date+"\"");
        schedule_info.add("\""+hour+"\"");
        schedule_info.add("\""+minute+"\"");
        schedule_info.add("\""+content+"\"");
        schedule_info.add(String.valueOf(schedule_key));
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
                <div class="details_div_container"></div> <!--일정 컨테이너-->
                <form action="/week09/jsp/create_schedule_action.jsp" onsubmit="return check_event()" id="input_date_div"> <!--일정 추가 영역-->
                    <input type="hidden" name="session_value" value="<%=key_value%>">
                    <input type="hidden" name="year_value" id=year_value>
                    <input type="hidden" name="month_value" id=month_value>
                    <input type="hidden" name="day_value" id=day_value>
                    <input type="hidden" name="input_apm_value" class="input_apm_value">
                    <input type="hidden" name="input_hour_value" class="input_hour_value">
                    <input type="hidden" name="input_minute_value" class="input_minute_value">
                    <div id="input_date_top">
                        <div class="time"> <!--시간-->
                            <button type="button" class="apm" id="input_apm" onclick="apm_change_event(this)">AM</button>
                            <div class="hour" id="input_hour">1</div>
                            <div class="hour_button_div">
                                <button type="button" class="hour_plus_btn" onclick="hour_plus_event(this,false)">+</button>
                                <button type="button" class="hour_minus_btn" onclick="hour_minus_event(this,false)">-</button>
                            </div>
                            <div class="minute" id="input_minute">00</div>
                            <div class="minute_button_div">
                                <button type="button" class="minute_plus_btn" onclick="minute_plus_event(this,false)">+</button>
                                <button type="button" class="minute_minus_btn" onclick="minute_minus_event(this,false)">-</button>
                            </div>
                        </div>
                        <p id="alert_content">내용을 입력해 주세요</p> <!--경고 문구-->
                        <input type="submit" id="add" value="추가">
                    </div>
                    <input type="text" id="input_date" placeholder="내용을 입력해 주세요(60자 이내)." name="content_value" maxlength="60"> <!--일정 내용-->
                </form>
            </div>
        </div>

        <div id="hidden_menu"> <!--오른쪽 메뉴-->
            <div id="hidden_menu_top">
                <button type="button" class="menu" onclick="show_menu_event()" >
                    <svg height="24" viewBox="0 0 24 24" width="24" focusable="false" style="pointer-events: none; display: block; width: 100%; height: 100%;"><path d="M21 6H3V5h18v1zm0 5H3v1h18v-1zm0 6H3v1h18v-1z"></path></svg>
                </button>
            </div>
            <div id="name_div">
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
    <footer>
        <input type="button" id="back_page" value="BACK" onclick="history.back()">
    </footer>
    <script>
        var today = new Date() // 오늘 날짜
        var today_year = today.getFullYear()
        var today_month = today.getMonth() + 1
        var today_day = today.getDate()
    
        window.onload = function () {
            make_month() // month 버튼들 만들기
            document.getElementById("year").innerHTML = today_year // 년도에 오늘 날짜 넣어놓기(초기값)
            var btn = document.getElementById("month" + today_month) // 오늘 월인 버튼 가져옴
            select_month_event(btn) // 오늘 월이 선택되게
            if('<%=rank_value%>' === "팀장"){
                document.getElementById("member_list").style.display='block' // 팀원 보이게
                make_me() // (나) 선택 버튼 생성
                make_member_list() // 팀원 목록 생성
            }
            else if('<%=rank_value%>' === "팀원"){
                document.getElementById("member_list").style.display='none'
            }
            have_shedule() // 스케줄 있으면 원 & 숫자 나타나게
            if('<%=key_value%>'!= '<%=session.getAttribute("key_value")%>'){ // 팀장이 팀원의 목록을 보는 경우 왼쪽 상단에
                document.getElementById("member_info").style.display='flex'
                document.getElementById("member_name_div").innerHTML= '<%=member_name_input%>'
                document.getElementById("member_id_div").innerHTML= '<%=member_id_input%>'
                document.getElementById("hidden_menu").style.right = '-260px'
                document.getElementById("dark_background").style.display = 'none'
                var modify_details = document.getElementsByClassName("modify_details")
                var delete_details = document.getElementsByClassName("delete_details")
                for(var i=0; i<modify_details.length; i++){ // 수정 삭제 버튼 안 보이게
                    modify_details[i].style.display="none"
                    delete_details[i].style.display="none"
                }
            }
        }

        function check_event() {
            var input_date = document.getElementById("input_date").value
            var input_hour_value = document.getElementsByClassName("input_hour_value")[0]
            var input_minute_value = document.getElementsByClassName("input_minute_value")[0]
            var input_apm_value = document.getElementsByClassName("input_apm_value")[0]

            if (input_date.trim() === "") {
                document.getElementById("alert_content").style.display = "block"
                return false
            }
            else {
                document.getElementById("alert_content").style.display = "none"
                if (input_hour_value.value === ""){
                    input_hour_value.value = "1";
                }
                if(input_minute_value.value === ""){
                    input_minute_value.value = "00";
                }
                if(input_apm_value.value === "") {
                    input_apm_value.value = "AM";
                }
            }
        }

        function td_click_event(id){ // 버튼 클릭 시 날짜에 따라 스케줄 보여줌
            if('<%=key_value%>'!= '<%=session.getAttribute("key_value")%>'){
                document.getElementById("input_date_div").style.display='none'
            }
            var part = id.split("-") // id는 2023-7-2 이런 형식
            var year = parseInt(part[0]); // 클릭한 버튼의 년도
            var month = parseInt(part[1]); 
            var day = parseInt(part[2]);
            if(day < 10){ // 10일보다 아래면 앞에 0을 붙여줌
                day = '0' + day
            }
            if(month < 10){
                month = '0' + month
            }
            var selected_date = year + "-" + month + "-" + day // 클릭된 버튼의 날짜 2023-07-02 이런 형식
            var schedule_list = <%=schedule_list%>
             
            var details_div_container = document.getElementsByClassName("details_div_container")[0] // 일정 전체를 담는 큰 컨테이너
            details_div_container.className="details_div_container"
            
            var have_shedule = false

            for(var i=0; i<schedule_list.length; i++){ // 전체 스케줄 개수만큼
                var date = schedule_list[i][0]// 저장된 스케줄의 날짜
         
                if(date == selected_date){ // 클릭된 버튼의 날짜와 저장된 스케쥴의 날짜가 같다면
                    var selected_hour = schedule_list[i][1] // 저장된 스케줄의 시
                    var selected_minute = schedule_list[i][2] // 저장된 스케줄의 분
                    var selected_content = schedule_list[i][3] // 저장된 스케쥴의 내용
                    var selected_key = schedule_list[i][4] // 저장된 스케줄의 키

                    if(selected_minute < 10){ // 02가 아니라 2 이런식으로 저장되기 때문에
                        selected_minute = '0'+ parseInt(selected_minute) 
                    }
                    if(selected_hour >= 12){ // 시간이 12 이상이면 PM으로 바뀌게
                        selected_hour = parseInt(selected_hour) - 12
                        var selected_apm = "PM"
                    }
                    else{ // 시간이 12 미만이면 AM
                        var selected_apm = "AM"
                    }
                    if(selected_hour == 0){
                        selected_hour = 12
                    }
                    var details_div = create_details_div(selected_hour, selected_minute, selected_content, selected_apm, selected_key,selected_date)
                    details_div_container.appendChild(details_div)
                    have_shedule = true
                    open_modal(year,month,day)
                }
            }
            if(!have_shedule){
                open_modal(year,month,day)
            }
        }

        function delete_details_event(key){
            if(confirm("정말로 삭제하시겠습니까?")){
                var key_input = document.createElement("input")
                key_input.type="hidden"
                key_input.name="key_input"
                key_input.value=key

                var session_input = document.createElement("input")
                session_input.type="hidden"
                session_input.name="session_input"
                session_input.value = <%=key_value%>

                var form = document.createElement("form")
                form.action="/week09/jsp/delete_schedule.jsp"

                form.appendChild(key_input)
                form.appendChild(session_input)
                document.body.appendChild(form)
                form.submit();
            }
        }

        function modify_details_submit_event(key,selected_date){
            var details_div = event.target.closest(".details_div")
            var modify_hour = details_div.getElementsByClassName("hour")[0].innerHTML
            var modify_apm = details_div.getElementsByClassName("apm")[0].innerHTML
            var modify_minute = details_div.getElementsByClassName("minute")[0].innerHTML
            var modify_details_content = details_div.getElementsByClassName("modify_details_content")[0].value

            var content_input = document.createElement("input")
            content_input.type="hidden"
            content_input.name="content_input"
            content_input.value=modify_details_content

            var key_input = document.createElement("input")
            key_input.type="hidden"
            key_input.name="key_input"
            key_input.value=key

            var date_input = document.createElement("input")
            date_input.type="hidden"
            date_input.name="date_input"
            date_input.value=selected_date

            var hour_input = document.createElement("input")
            hour_input.type="hidden"
            hour_input.name = "hour_input"
            hour_input.value= modify_hour

            var apm_input = document.createElement("input")
            apm_input.type="hidden"
            apm_input.name = "apm_input"
            apm_input.value= modify_apm

            var minute_input = document.createElement("input")
            minute_input.type="hidden"
            minute_input.name = "minute_input"
            minute_input.value= modify_minute

            var session_input = document.createElement("input")
            session_input.type="hidden"
            session_input.name="session_input"
            session_input.value = <%=key_value%>

            var form = document.createElement("form")
            form.action="/week09/jsp/modify_schedule.jsp"

            form.appendChild(hour_input)
            form.appendChild(apm_input)
            form.appendChild(minute_input)
            form.appendChild(content_input)
            form.appendChild(key_input)
            form.appendChild(session_input)
            form.appendChild(date_input)
            document.body.appendChild(form)
            form.submit();
        }
        unction modify_details_event(selected) { // 수정 버튼 누를 시
            var details_div = selected.closest('.details_div')
            var details_time = details_div.getElementsByClassName("details_time")[0]
            var details_content = details_div.getElementsByClassName("details_content")[0]
            var modify_details_time = details_div.getElementsByClassName("modify_details_time")[0]
            var modify_details_content = details_div.getElementsByClassName("modify_details_content")[0]
            var modify_details = details_div.getElementsByClassName("modify_details")[0]
            var delete_details = details_div.getElementsByClassName("delete_details")[0]
            var modify_details_submit_btn = details_div.getElementsByClassName("modify_details_submit_btn")[0]
            var modify_details_cancel_btn = details_div.getElementsByClassName("modify_details_cancel_btn")[0]
    
            details_time.style.display='none'
            details_content.style.display='none'
            modify_details.style.display='none'
            delete_details.style.display='none'
            
            modify_details_time.style.display='flex'
            modify_details_content.style.display='flex'
            modify_details_submit_btn.style.display='inline-block'
            modify_details_cancel_btn.style.display='inline-block'
        }
    
        function modify_details_cancel_event(selected){ // 수정 취소 버튼 누를시
            var details_div = selected.closest('.details_div')
            var details_time = details_div.getElementsByClassName("details_time")[0]
            var details_content = details_div.getElementsByClassName("details_content")[0]
            var modify_details_time = details_div.getElementsByClassName("modify_details_time")[0]
            var modify_details_content = details_div.getElementsByClassName("modify_details_content")[0]
            var modify_details = details_div.getElementsByClassName("modify_details")[0]
            var delete_details = details_div.getElementsByClassName("delete_details")[0]
            var modify_details_submit_btn = details_div.getElementsByClassName("modify_details_submit_btn")[0]
            var modify_details_cancel_btn = details_div.getElementsByClassName("modify_details_cancel_btn")[0]
    
            details_time.style.display='flex'
            details_content.style.display='flex'
            modify_details.style.display='inline-block'
            delete_details.style.display='inline-block'
    
            modify_details_time.style.display='none'
            modify_details_content.style.display='none'
            modify_details_submit_btn.style.display='none'
            modify_details_cancel_btn.style.display='none'
        }

        function close_modal_event() { // 초기화 해주는 느낌
            document.getElementById("input_date").value = ""
            document.getElementById("alert_content").style.display = "none" // 경고문 사라지게

            var hour = document.getElementById("input_hour")
            var minute = document.getElementById("input_minute")
            var apm = document.getElementById("input_apm")
            var modify_details_content = document.getElementsByClassName("modify_details_content")
            var details_div_container = document.getElementsByClassName("details_div_container")[0]
            
            hour.innerHTML = "1"
            minute.innerHTML = "00"
            apm.innerHTML = "AM"

            hour.value = "1";
            minute,value = "00";
            apm.value = "AM";

            for (var i = 0; i < modify_details_content.length; i++) {
                modify_details_content[i].value = ""
                modify_details_cancel_event(document.getElementsByClassName("details_div")[i])
            }
            while (details_div_container.firstChild) { // 기존 일정 지워줌
                details_div_container.removeChild(details_div_container.firstChild);
            }
            document.getElementById("modal_overlay").style.display = "none"
            document.getElementById("modal").style.display = "none"
        }

        function show_menu_event() { // 숨겨진 메뉴 보여줌
            document.getElementById("name").innerHTML='<%=name_value%>'
            document.getElementById("id").innerHTML='<%=id_value%>'
            document.getElementById("phone").innerHTML='<%=phone_value%>'
            document.getElementById("rank").innerHTML='<%=rank_value%>'
            document.getElementById("department").innerHTML='<%=department_value%>'
            var hidden_menu = document.getElementById("hidden_menu")
            var dark_background = document.getElementById("dark_background")
    
            if (dark_background.style.display != 'block') {
                hidden_menu.style.right = '0'
                dark_background.style.display = 'block'
            }
            else {
                hidden_menu.style.right = '-260px'
                dark_background.style.display = 'none'
            }
        }
        function select_month_event(selected) { // selected는 버튼
            var selected_month = selected.value // 선택된 월
            var button = document.getElementsByClassName("month") // 월 버튼들 가져옴
            for (var i = 0; i < 12; i++) {
                button[i].style.backgroundColor = 'white' // 우선 모든 버튼을 하얀색으로 설정함
            }
            selected.style.backgroundColor = '#E16A9D'
            delete_calender() // 원래 있던 달력 지우기
            make_calender(selected_month) // 선택된 월에 맞는 달력 그리기
        }
    
        function prev_year_event() { // 이전 년도
            var year = document.getElementById("year").innerHTML
            year = parseInt(year) - 1
            document.getElementById("year").innerHTML = year
            var month = document.getElementsByClassName("month")
            for(var i=0; i<month.length; i++){ 
                month[i].style.backgroundColor ="white"
            }
            delete_calender()
        }
    
        function next_year_event() { // 다음 년도
            var year = document.getElementById("year").innerHTML
            year = parseInt(year) +1
            document.getElementById("year").innerHTML = year
            var month = document.getElementsByClassName("month")
            for(var i=0; i<month.length; i++){ 
                month[i].style.backgroundColor ="white"
            }
            delete_calender()
        }
    
        function hour_plus_event(selected, is_modify) {
            if(is_modify){ // 수정 영역이면
                var hour_div = selected.closest('.modify_details_time') // 상위에 가까운 modify_details_time 찾아 가져옴
            }
            else{
                var hour_div = selected.closest('#input_date_div')
            }
            var hour_element = hour_div.getElementsByClassName("hour")[0].innerHTML
            var hour = parseInt(hour_element, 10)
            hour += 1
            if (hour == 13) {
                hour = 1
            }
            hour_div.getElementsByClassName("hour")[0].innerHTML = hour
            hour_div.getElementsByClassName("input_hour_value")[0].value= hour
        }
    
        function hour_minus_event(selected,is_modify) {
            if(is_modify){
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
            hour_div.getElementsByClassName("input_hour_value")[0].value= hour
        }
    
        function minute_plus_event(selected,is_modify) {
            if(is_modify){
                var minute_div = selected.closest('.modify_details_time')
            }
            else{
                var minute_div = selected.closest('#input_date_div')
            }
            var minute_element = minute_div.getElementsByClassName("minute")[0].innerHTML
            var minute = parseInt(minute_element, 10) + 1
            if (minute == 60) {
                minute = 0
            }
            minute = (minute < 10 ? '0' : '') + minute // 10 이하일 때 2 -> 02
            minute_div.getElementsByClassName("minute")[0].innerHTML = minute
            minute_div.getElementsByClassName("input_minute_value")[0].value= minute
        }
    
        function minute_minus_event(selected,is_modify) {
            if(is_modify){
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
                minute = (minute < 10 ? '0' : '') + minute
                minute_div.getElementsByClassName("minute")[0].innerHTML = minute
                minute_div.getElementsByClassName("input_minute_value")[0].value= minute
            }
        }
    
        function apm_change_event(selected) {
            var input_date_div = selected.closest("#input_date_div")
            if (selected.innerHTML == "AM") {
                selected.innerHTML = "PM"
                input_date_div.getElementsByClassName("input_apm_value")[0].value="PM"
            }
            else{
                selected.innerHTML = "AM"
                input_date_div.getElementsByClassName("input_apm_value")[0].value="AM"
            }
        }

        function select_member_event(selected){ // 팀원 선택 시
            var member_name = selected.getElementsByClassName('member_name')[0].innerHTML
            var member_id = selected.getElementsByClassName('member_id')[0].innerHTML
            var member_key = selected.getElementsByClassName("member_key")[0].value
            var member_department = selected.getElementsByClassName("member_department")[0].value

            var member_info = document.getElementById("member_info")
            var member_name_div=document.getElementById("member_name_div")
            var member_id_div=document.getElementById("member_id_div")
            var hidden_menu = document.getElementById("hidden_menu")
            var dark_background = document.getElementById("dark_background")
    
            member_info.style.display='flex'
            member_name_div.innerHTML= member_name
            member_id_div.innerHTML= member_id
            hidden_menu.style.right = '-260px'
            dark_background.style.display = 'none'
            
            var member_key_input = document.createElement("input")
            member_key_input.type = "hidden"
            member_key_input.name = "member_key"
            member_key_input.value = member_key

            var member_id_input = document.createElement("input")
            member_id_input.type = "hidden"
            member_id_input.name = "member_id_input"
            member_id_input.value = member_id

            var member_department_input = document.createElement("input")
            member_department_input.type = "hidden"
            member_department_input.name = "member_department_input"
            member_department_input.value = member_department
       
            var member_name_input = document.createElement("input")
            member_name_input.type = "hidden"
            member_name_input.name = "member_name_input"
            member_name_input.value = member_name

            var form = document.createElement("form")
            form.action="/week09/jsp/main.jsp"

            form.appendChild(member_key_input)
            form.appendChild(member_id_input)
            form.appendChild(member_department_input)
            form.appendChild(member_name_input)
            document.body.appendChild(form)
            form.submit()
        }

        function have_shedule(){ // 스케줄 있으면 원 & 숫자 나타나게
            var schedule_count_list = <%=schedule_count_list%>
            for(var i=0; i<schedule_count_list.length; i++){
                var schedule_date = new Date(schedule_count_list[i][0]) // 저장된 날짜 가져옴
                var schedule_day = schedule_count_list[i][4]
                var schedule_month = schedule_count_list[i][3]
                var schedule_year = schedule_count_list[i][2]
                var schedule_count = schedule_count_list[i][1] // 저장된 일정 갯수 가져옴
                var day_element = document.getElementById(schedule_year+"-"+schedule_month +"-"+schedule_day) // 저장된 날짜의 id를 가진 div를 가져옴
                if (day_element) { // 있다면 즉 -> 일정이 여러개라면
                    var existing_circle = day_element.getElementsByClassName("circle")
                    if (existing_circle.length > 0) { // 이미 존재하는 일정이 1개 이상이면
                        if(schedule_count >= 10){ // 일정의 수가 10개 이상이면
                            existing_circle[0].innerHTML = "9+" // 9+로 표시
                        }
                        else{
                            existing_circle[0].innerHTML = schedule_count 
                        }
                    } else { // 없다면
                        var circle_div = document.createElement("div"); // circle 만들어줌
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
             
        function create_details_div(selected_hour, selected_minute, selected_content, selected_apm, selected_key, selected_date){
            var details_div = document.createElement("div") // 각 일정 전체를 담는 div (핑크 테두리)
            details_div.className="details_div"

            var details_time = document.createElement("div") // 일정의 시간
            details_time.className="details_time"
            details_time.innerHTML =selected_apm +" " + selected_hour + " : " + selected_minute

            var modify_details_time = document.createElement("div") // 수정 클릭시 일정의 시간
            modify_details_time.className="modify_details_time"

            var apm = document.createElement("button") // 수정 클릭시 apm 버튼
            apm.className="apm"
            apm.type="button"
            apm.innerHTML="AM"
            apm.onclick=function(){
                apm_change_event(this)
            }
            var hour = document.createElement("div") // 수정 클릭시 일정의 시
            hour.className="hour"
            hour.innerHTML=selected_hour

            var hour_button_div = document.createElement("div") 
            hour_button_div.className="hour_button_div"
            
            var hour_plus_btn = document.createElement("button")
            hour_plus_btn.className="hour_plus_btn"
            hour_plus_btn.type="button"
            hour_plus_btn.innerHTML="+"
            hour_plus_btn.onclick=function(){ // 수정 클릭시 라는 걸 알려주기 위해 true
                hour_plus_event(this,true)
            }

            var hour_minus_btn = document.createElement("button")
            hour_minus_btn.className="hour_minus_btn"
            hour_minus_btn.type="button"
            hour_minus_btn.innerHTML="-"
            hour_minus_btn.onclick=function(){
                hour_minus_event(this,true)
            }

            var minute = document.createElement("div") // 수정 클릭시 일정의 분
            minute.className="minute"
            minute.innerHTML=selected_minute

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

            var details = document.createElement("div") // 수정 클릭시 나오는 아래 부분
            details.className="details"

            var details_content = document.createElement("div") // 일정의 내용 
            details_content.className="details_content"
            details_content.innerHTML=selected_content

            var modify_details_content = document.createElement("input") // 수정 클릭시 일정의 내용 입력 부분
            modify_details_content.type="text"
            modify_details_content.className="modify_details_content"
            modify_details_content.name = "modify_details_content"
            modify_details_content.value = selected_content
            modify_details_content.placeholder=selected_content

            var button_div = document.createElement("div") // 수정 삭제 버튼 div
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
            delete_details.onclick = function(){
                delete_details_event(selected_key)
            }

            var modify_details_submit_btn = document.createElement("button") // 수정 하고 제출
            modify_details_submit_btn.className="modify_details_submit_btn"
            modify_details_submit_btn.innerHTML="완료"
            modify_details_submit_btn.onclick = function(){
                modify_details_submit_event(selected_key,selected_date)
            }

            var modify_details_cancel_btn = document.createElement("button")
            modify_details_cancel_btn.className="modify_details_cancel_btn"
            modify_details_cancel_btn.innerHTML="취소"
            modify_details_cancel_btn.onclick=function(){
                modify_details_cancel_event(this)
            }

            button_div.appendChild(modify_details)
            button_div.appendChild(delete_details)
            button_div.appendChild(modify_details_submit_btn)
            button_div.appendChild(modify_details_cancel_btn)

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
            
            return details_div
        }

        function open_modal(year, month, day) {
            if(day < 10){
                day = day - '0' // ex) 02를 2로 표현하기 위해
            }
            if(month < 10){
                month = month - '0'
            }
            document.getElementById("modal_overlay").style.display = "block"
            document.getElementById("modal").style.display = "block"
            document.getElementById("modal_year").innerHTML = year
            document.getElementById("modal_month").innerHTML = month
            document.getElementById("modal_day").innerHTML = day
            document.getElementById("year_value").value = year
            document.getElementById("month_value").value = month
            document.getElementById("day_value").value = day
        }
    
        function make_me(){ // (나) 버튼
            var id = '<%=id_value%>'
            var name = '<%=name_value%>'
            var button = document.createElement("button")
            button.type="button"
            button.className="member"
            button.onclick=function(){
                location.href="/week09/jsp/main.jsp"
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

        function make_member_list(){ // 팀원 목록 만들어줌
            var member_list = <%=member_list%> 

            for(var i=0; i<member_list.length; i++){
                var button = document.createElement("button")
                button.type="button"
                button.className="member"
                button.onclick=function(){
                    select_member_event(this)
                }
                var member_id = document.createElement("div")
                member_id.className="member_id"
                member_id.innerHTML=member_list[i][0]

                var member_name = document.createElement("div")
                member_name.className="member_name"
                member_name.innerHTML=member_list[i][1]

                var member_key = document.createElement("input")
                member_key.type="hidden"
                member_key.className="member_key"
                member_key.value = member_list[i][2]

                var member_department = document.createElement("input")
                member_department.type="hidden"
                member_department.className="member_department"
                member_department.value = member_list[i][3]

                button.appendChild(member_name)
                button.appendChild(member_id)
                button.appendChild(member_key)
                button.appendChild(member_department)

                document.getElementById("member_list").appendChild(button)
            }
        }

        function make_calender(selected_month) {
            var table = document.getElementById("calender")
            var selected_year = document.getElementById("year").innerHTML
            var year_cnt = 0
            var row_cnt = 0;

            if (selected_month == 1 || selected_month == 3 || selected_month == 5 || selected_month == 7 || selected_month == 8 || selected_month == 10 || selected_month == 12) {
                year_cnt = 31
                row_cnt = 5
            }
            else if (selected_month == 2) {
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
                    var day = i * 7 + j + 1 // 해당 월의 날짜
                    if (day <= year_cnt) {
                        var div = document.createElement("div")
                        div.classList.add("day_txt")
                        div.innerHTML = day
                        td.appendChild(div)
                        td.id = selected_year+"-"+selected_month +"-"+day
                        td.onclick = function () {
                            td_click_event(this.id) // 2023-08-04 이런식
                        }
                    }
                    tr.appendChild(td)
                }
                table.appendChild(tr)
            }
            have_shedule(); // 일정있으면 동그라미 표시
        }
    
        function make_month(){ // month 버튼 만들기
            var month_div = document.getElementById("month_div")
            for(var i=1; i<13; i++){
                var button = document.createElement("input")
                button.type= "button"
                button.className = "month" // 클래스 = month
                button.id = "month"+i // 아이디 = month 1, month 2....
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
    </script>
</body>