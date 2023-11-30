<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    String id_value = request.getParameter("id_value");
    String pw_value = request.getParameter("pw_value");
    int key_value = 0;
    String phone_value ="";
    String name_value="";
    String rank_value="";
    String department_value="";
    int check = 0; // pw와 id 같은지

    Pattern id_pattern = Pattern.compile("^[a-zA-Z0-9]{6,20}$");
    Pattern pw_pattern = Pattern.compile("^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,30}$");
    if(!id_pattern.matcher(id_value).matches() || !pw_pattern.matcher(pw_value).matches()){ // 정규식에 맞지 않을 경우 로그인 페이지로 팅김
        response.sendRedirect("/week09/jsp/log_in.jsp");
        return;
    }

    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");
        
        String sql = "SELECT * FROM user WHERE id= ? AND pw = ?";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, id_value);
        query.setString(2, pw_value);
        ResultSet result = query.executeQuery();

        //만약 입력한 pw 값과 입력한 id의 저장된 pw값이 같으면 check = 1
        if(result.next()){
            check = 1;
            key_value = result.getInt("user_key");
            phone_value = result.getString("phone");
            name_value  = result.getString("name");
            rank_value = result.getString("rank");
            department_value = result.getString("department");

            session.setAttribute("key_value",key_value);
            session.setAttribute("pw_value",pw_value);
            session.setAttribute("phone_value",phone_value);
            session.setAttribute("name_value",name_value);
            session.setAttribute("id_value",id_value);
            session.setAttribute("rank_value",rank_value);
            session.setAttribute("department_value",department_value);
        }
    } catch(Exception e){
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
        if(<%=check%>==0){ // pw와 id가 다르면
            alert("로그인에 실패했습니다.")
            history.back()
        }
        else{
            location.href="/week09/jsp/main.jsp"
        }
    </script>
</body>