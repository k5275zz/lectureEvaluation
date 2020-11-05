<%@page import="javax.mail.internet.MimeMessage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="java.util.Properties" %> <!-- 속성을 정의하는데 쓰이는 라이브러리 -->
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정한 스크립트 구문을 출력하고자 할때 사용. -->
<% 
//이메일 전송 메소드

	UserDAO userDAO = new UserDAO();
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	//사용자한테 요청을 받되 그 요청은 한글로 받는다
	request.setCharacterEncoding("UTF-8");
	//request.getParameter로 값을 받아온다.
	String reportTitle = null;
	String reportContent = null;
	if(request.getParameter("reportTitle") != null){
		reportTitle = request.getParameter("reportTitle");  
	}
	if(request.getParameter("reportContent") != null){
		reportContent = request.getParameter("reportContent");  
	}
	//한개라도 null 값이 있다면 이전화면으로 돌려준다.
	if(reportTitle == null || reportContent == null || reportTitle == "" || reportContent == "" ){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back()");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	 
	
	/* 구글 smtp 양식*/
	//신고내용을 잘 기입하였다면
	String host = "http://localhost:8080/Lecture_Evaluation/";
	String from = "codms2ek@gmail.com";
	String to = "dlcodms1231@naver.com"; //받는사람 쪽으로 신고내용을 받아준다.
	String subject = "강의평가 사이트에서 접수된 신고 메일입니다.";
	String content = "신고자: "+userID +
					 "<br>제목: " + reportTitle +
					 "<br>내용: " + reportContent;
	//실제로 smtp에 접속하기 위한 정보
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	//이메일 전송부분
	try{
		//실제로 구글 계정으로 지메일의 계정 인증 수행 사용자한테 관리자의 메일주소로 보내줌
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO,toAddr);
		//메일 안에 담길 내용
		msg.setContent(content, "text/html;charset=UTF8");
		Transport.send(msg);//실제로 메세지를 전송
		
	}catch(Exception e){
		e.printStackTrace();
		//오류발생시 뒤로 돌아가도록
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생하였습니다.');");
		script.println("history.back()");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	try{

		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('정상적으로 신고되었습니다.');");
		script.println("history.back()");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;
	
	}catch(Exception e){
		e.printStackTrace();
	}	//unreachable code 에러 = 코드가 절대로 실행될 수 없는 위치에 있다.
	//대부분이 리턴문 문제이다.
	//return을 없애면 실행이 되긴함 . 그럼 밑으로 내려오질 못한다는 건데
%>



