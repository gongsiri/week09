<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    String name_value = request.getParameter("name_value");
    String phone_value = request.getParameter("phone_value");
    String id_value="";
    int check=0;

    Pattern name_pattern = Pattern.compile("^[가-힣]{2,5}$");
    Pattern phone_pattern = Pattern.compile("^01[0179][0-9]{7,8}$");

    if(!name_pattern.matcher(name_value).matches() || !phone_pattern.matcher(phone_value).matches()){
        response.sendRedirect("/week09/jsp/find_id.jsp");
        return;
    }

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

    String sql = "SELECT * FROM user WHERE name= ? AND phone= ?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, name_value);
    query.setString(2, phone_value);
    ResultSet result = query.executeQuery();
    if(result.next()){
        id_value = result.getString("id");
        check=1;
    }
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/week09/css/find_id_action.css">
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
        <h1>아이디 찾기 결과</h1>
        <h3 id="result">입력한 정보로 조회된 아이디는 <%=id_value%>입니다.</h3>
        <div id="button_div">
            <input type="button" value="로그인" id="log_in" onclick="location.href='/week09/jsp/log_in.jsp'">
            <input type="button" value="다시 찾기" id="refind" onclick="location.href='/week09/jsp/find_id.jsp'">
        </div>
    </main>
    <footer>
        <input type="button" id="back_page" value="BACK" onclick="history.back()">
    </footer>
</body>