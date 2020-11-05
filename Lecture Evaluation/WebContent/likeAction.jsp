<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <!-- 속성을 정의하는데 쓰이는 라이브러리 -->
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.LikeyDAO"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정한 스크립트 구문을 출력하고자 할때 사용. -->

<%! 
	public static String getClientIP(HttpServletRequest request){//사용자의 ip주소를 알아내는 함수
	String ip = request.getHeader("X-FORWARDED-FOR");
	//프록시 서버를 사용한 사용자라 하더라도 왠만해서 ip값을 가져올수 있다.
	if(ip == null || ip.length()==0){
		ip = request.getHeader("Proxy-Client-IP");
	}
	if(ip == null || ip.length() == 0){
		ip = request.getHeader("WL-Proxy-Client-IP");
	}
	if(ip == null || ip.length() == 0){
		ip = request.getRemoteAddr();
	}
	return ip;
}
%>

<% 
	String userID = null;

	if(session.getAttribute("userID") != null) {

		userID = (String) session.getAttribute("userID");

	}

	if(userID == null) {

		PrintWriter script = response.getWriter();

		script.println("<script>");

		script.println("alert('로그인을 해주세요.');");

		script.println("location.href = 'userLogin.jsp'");

		script.println("</script>");

		script.close();

		return;

	}

	request.setCharacterEncoding("UTF-8");

	String evaluationID = null;

	if(request.getParameter("evaluationID") != null) {

		evaluationID = (String) request.getParameter("evaluationID");

	}

	EvaluationDAO evaluationDAO = new EvaluationDAO();
	LikeyDAO likeyDAO = new LikeyDAO();
	
	int result = likeyDAO.like(userID, evaluationID, getClientIP(request));
	
	
	if (result == 1) {
			result = evaluationDAO.like(evaluationID); 
			if(result == 1){
				PrintWriter script = response.getWriter();

				script.println("<script>");

				script.println("alert('추천이 완료되었습니다.');");

				script.println("location.href='index.jsp'");

				script.println("</script>");

				script.close();

				return;
			
		} else {

			PrintWriter script = response.getWriter();

			script.println("<script>");

			script.println("alert('데이터베이스 오류가 발생했습니다.');");

			script.println("history.back();");

			script.println("</script>");

			script.close();

			return;

		}

	}else {
			PrintWriter script = response.getWriter();

			script.println("<script>");

			script.println("alert('자신이 쓴 글만 삭제 가능합니다.');");

			script.println("history.back();");

			script.println("</script>");

			script.close();

			//return;
	
		}
%>



