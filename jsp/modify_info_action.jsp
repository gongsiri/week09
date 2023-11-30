<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.regex.Pattern" %>

<%
    request.setCharacterEncoding("utf-8");
    Object key_value_ob = session.getAttribute("key_value");
    if(key_value_ob == null){ // 로그인 된 상태가 아니라면
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }
    int key_value = Integer.parseInt(key_value_ob.toString()); 
    int session_value = Integer.parseInt(request.getParameter("session_input"));
    String id_value = request.getParameter("id_value");
    String pw_value = request.getParameter("pw_value");
    String phone_value = request.getParameter("phone_value");
    String name_value = request.getParameter("name_value");
    String rank_value = request.getParameter("rank_value");
    String department_value = request.getParameter("department_value");
    int check = 0;

    Pattern pw_pattern = Pattern.compile("^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,30}$");
    Pattern name_pattern = Pattern.compile("^[가-힣]{2,5}$");
    Pattern phone_pattern = Pattern.compile("^01[0179][0-9]{7,8}$");
    if(!pw_pattern.matcher(pw_value).matches() || !name_pattern.matcher(name_value).matches() || !phone_pattern.matcher(phone_value).matches() || (!"팀원".equals(rank_value)&&!"팀장".equals(rank_value)) || (!"디자인팀".equals(department_value)&&!"개발팀".equals(department_value))){
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }

    if(key_value != session_value){ // 현재 로그인 된 사람과 정보 수정할 사람이 다르면
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }
    
    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

        if(rank_value.equals("팀장")){ // 팀장이 있는데 팀장 선택 했을 시
            String sql = "SELECT * FROM user WHERE department =? AND rank =?"; // 팀장이 있는데 선택했을 시
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, department_value);
            query.setString(2, rank_value);
            ResultSet result = query.executeQuery();
            if(result.next()){
                check = 1;
            }
        }
        
        if(check == 0){
            String sql2 = "UPDATE user SET pw=?, name=?, phone=?, rank=?, department=? WHERE user_key=?"; 
            PreparedStatement query2 = connect.prepareStatement(sql2);
            query2.setString(1, pw_value);
            query2.setString(2, name_value);
            query2.setString(3, phone_value);
            query2.setString(4, rank_value);
            query2.setString(5, department_value);
            query2.setInt(6, session_value);
            query2.executeUpdate();

            session.setAttribute("name_value", name_value); // 세션 값 업데이트
            session.setAttribute("pw_value", pw_value);
            session.setAttribute("phone_value", phone_value);
            session.setAttribute("rank_value", rank_value);
            session.setAttribute("department_value", department_value);
        }
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
         if(<%=check%> == 1){
            alert("팀장은 이미 존재합니다.")
            history.back()
        }else{
            location.href="/week09/jsp/main.jsp"
        }
    </script>
</body>
</html>