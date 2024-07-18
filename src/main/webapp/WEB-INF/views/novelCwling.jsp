<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
	String res = (String) request.getAttribute("res");



%>
<html>
<head>
<meta charset="UTF-8">
<title>Novel Crawling</title>
</head>
<body>
<%=res %>개 크롤링 완료!
</body>
</html>