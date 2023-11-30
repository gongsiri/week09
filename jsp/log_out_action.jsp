<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%

    request.setCharacterEncoding("utf-8");
    Object id_value_ob = session.getAttribute("id_value");
    if(id_value_ob == null){
        response.sendRedirect("/week09/jsp/log_in.jsp");
    }

    session.invalidate();
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        alert("로그아웃 됐습니다!")
        location.href="/week09/jsp/log_in.jsp"
    </script>
</body>