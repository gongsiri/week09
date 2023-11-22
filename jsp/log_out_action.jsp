<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%
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