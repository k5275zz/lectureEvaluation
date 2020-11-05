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
<%//이메일 전송 메소드

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
	
	boolean emailChecked = userDAO.getUserEmailChecked(userID); 
	if(emailChecked == true){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증 된 회원입니다.');");
		script.println("location.href = 'index.jsp'");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	/* 구글 smtp 양식*/
	//사용자에게 인증메일을 보내주는 메소드
	String host = "http://localhost:8080/Lecture_Evaluation/";
	String from = "codms2ek@gmail.com";
	String to = userDAO.getUserEmail(userID);
	String subject = "강의평가를 위한 이메일 인증 메일입니다.";
	String content = "다음 링크에 접속하여 이메일 인증을 진행하세요."+
		"<a href='"+ host +"emailCheckAction.jsp?code="+new SHA256().getSHA256(to)+"'>이메일 인증하기</a>";
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
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"><!-- 모바일 웹에 맞춰지는 반응형기능 -->
	<title>강의평가 웹사이트</title>
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
	
	<!-- <script src="./js/jquery.min.js"></script>
	<script src="./js/popper.min.js"></script>
	<script src="./js/bootstrap.min.js"></script> -->
</head>
<body>
	 <nav class="navbar navbar-expand-md navbar-dark bg-dark">
	 	<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
	 	
	 	<button class="navbar-toggler" type="button"
	 		data-toggle="collapse" data-target="#nav">
	 		<span class="navbar-toggler-icon"></span>
	 	</button>
	 	
	 	<div class="collapse navbar-collapse" id="nav">
      		<ul class="navbar-nav mr-auto">
      			<li class="nav-item active">
      				<a class="nav-link href="index.jsp">메인</a>
      			</li>
      			<li class="nav-item dropdown">
      				<a class="nav-link dropdown-toggle" id="dropdown" 
      				data-toggle="dropdown">회원관리</a>
      				<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if(userID == null){//로그인이 안된 상태라면
%>      				
      					<a class="dropdown-item" href="userLogin.jsp">로그인</a>
      					<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
<%
	}else {
%>
      					<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
	}
%>
      				</div>
      			</li>			
      		</ul>
      		<!-- aria-label =시각장애인들을 위한 정보-->
      		      		<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
      		<!-- 이중타입? 타입을 두개나 주는게 가능한가? 타입을 text로 그리고 name은 search로 준다.그럼 검색기능을 사용하면 get방식을 통해 url에 url+serach=검색어로 뜨게 된다 -->
      		<!-- 다른 모든 페이지에도 적용시켜준다. -->
      			<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
      			<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
      		</form>
      		
      	</div>
	</nav>		
	<section class="container mt-3" style="max-width: 560px;"> <!-- 컨테이너는 반응형으로 알아서 작아지는데 도움을 준다 --> <!-- 로그인창과 거리를 좀 떨어뜨리고 싶어서 mt-3을 준다. -->
		<div class="alert alert-succes" role="alert" style="background: Aquamarine;">
			이메일 주소 인증 메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가셔서 인증해주세요.
		</div>
	</section>	
	<footer class="bg-dark mt-4 p-5 text-center " style="color:white;">
		Copyright &copy; 2020 이채은 All Rights Reserved.
	</footer>
	
	<!-- 자바스크립트 부트스트랩 연결로 고생함
	고치려고 부트스트립 dropdown ,collapse navbar-collapse에 대해 자세히 공부하였고
	https://zetawiki.com/wiki/%EB%B6%80%ED%8A%B8%EC%8A%A4%ED%8A%B8%EB%9E%A9_%EB%82%B4%EB%B9%84%EA%B2%8C%EC%9D%B4%EC%85%98%EB%B0%94_%EC%9E%90%EB%8F%99%EC%A0%91%EA%B8%B0_navbar-collapse
	에서 collapse navbar-collapse에 다시 공부하다 우연히 다시 제이쿼리문을 넣어서 오류를 고침
	문제점:잘못된 제이쿼리 파일(경로)를(을) 넣어 부트스트랩이 반응을 하지않았음(버튼을 누르면 서브창이 내려와야하는데 내려오지 않음).코드에 문제가 있는줄 알고 한참 찾아보았음.
	해결방법:문장을 하나씩 지워가며 무엇이 문제인지 찾아보았음.부트스트랩에 문제가 없자 제이쿼리에 문제가 있음을 깨달음 -->
	
	<!-- js파일을 마지막에 넣어주는 이유는 브라우저가 스크립트 파일을 읽을 때 시간이 걸려서 마지막에 로드하는게 좋아서라고 합니다. -->
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/popper.min.js"></script>
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	
</body>
</html>