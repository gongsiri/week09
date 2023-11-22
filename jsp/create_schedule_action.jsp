<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    Object id_value_ob = session.getAttribute("id_value");
    String id_value = String.valueOf(id_value_ob);
    String apm_value = request.getParameter("apm_value");
    String hour_value = request.getParameter("hour_value");
    String minute_value = request.getParameter("minute_value");
    String content_value = request.getParameter("content_value");

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week09","gongsil","1005");

    //입력된 id를 기준으로 유저들 가져옴
    String sql = "SELECT * FROM user WHERE id=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, id_value);
    ResultSet result = query.executeQuery();
    while(result.next()){ // 유저가 있으면 check = 1
        check=1;
    }
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        if(<%=check%>==1){ // 중복되면
            alert("<%=id_value%>"+"는 사용할 수 없습니다.")
            window.close();
        }
        else{
            if(confirm("<%=id_value%>"+"는 사용할 수 있습니다.\n" +"사용하시겠습니까?")){
                window.opener.document.getElementById("id_duplication_check_btn").style.display="none" // window.opener : 이 창을 호출한 부모창 -> 중복 버튼 없앰
                window.opener.document.getElementById("id").readOnly = true; // 아이디 입력 못 하게 막자
                window.close();
            }
            else{
                window.close();
            }
        }
    </script>

</body>