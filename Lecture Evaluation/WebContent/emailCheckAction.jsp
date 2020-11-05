<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정한 스크립트 구문을 출력하고자 할때 사용. -->
<%//이메일 인증처리
	request.setCharacterEncoding("UTF-8"); // 한글 파라미터 post 전송 경우
	String code = null;
	if(request.getParameter("code") != null){
		code = request.getParameter("code");//사용자가 id값을 잘 전송했다면 ID값에 사용자의 값을 담아준다.
	}
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if(session.getAttribute("userID") != null){//사용자가 이미 로그인한 상태라면 userID변수로 초기화해주면 된다.
 		userID = (String)session.getAttribute("userID"); //세션값은 기본적으로 오브젝트값으로 반환하기에 String으로 형변환
	}
	if(userID == null){//로그인이 안되어있다면 로그인페이지로 이동
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");//계속 로그인을 해달라고 연결되어서 확인해보았더니  userID의 세션 값을 가져오는 곳에서 session을 request로 써서 오류발생하였음
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	String userEmail = userDAO.getUserEmail(userID); //사용자 이메일 불러오기
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true:false;//사용자가 받은 해시값과 일치하는지 확인
	if(isRight == true){
		userDAO.setUserEmailChecked(userID);//인증이 완료 되었으나 emailchecked 값이 0그대로여서 userDAO 클래스의 setuserEmailChecked를 찾아보았고 sql 문에서 where 오타를 발견하여 수정하였음
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>"); 
		script.close();
		return;
	}else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
%>