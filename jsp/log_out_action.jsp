<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%
    request.setCharacterEncoding("utf-8");
    Object key_value_ob = session.getAttribute("key_value");
    if(key_value_ob == null){
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
        location.href="/week09/jsp/log_in.jsp"
    </script>
</body>