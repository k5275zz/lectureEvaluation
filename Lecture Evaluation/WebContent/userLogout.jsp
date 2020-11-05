<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%//로그아웃 처리 페이지
	session.invalidate();
%>

<script>
	location.href = 'index.jsp';
</script>