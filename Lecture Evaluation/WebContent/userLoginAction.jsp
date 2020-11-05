<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정한 스크립트 구문을 출력하고자 할때 사용. -->
<%//회원가입을 처리하는 함수
	request.setCharacterEncoding("UTF-8"); // 한글 파라미터 post 전송 경우
	String userID = null;
	String userPassword = null;
	if(request.getParameter("userID") != null){
 		userID = request.getParameter("userID");//사용자가 id값을 잘 전송했다면 ID값에 사용자의 값을 담아준다.
	}
	if(request.getParameter("userPassword") != null){
		userPassword = request.getParameter("userPassword");//사용자가 id값을 잘 전송했다면 ID값에 사용자의 값을 담아준다.
	}
	if(userID == null || userPassword == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	//실제로 회원가입 시키는 부분
	UserDAO userDAO = new UserDAO();
	int result = userDAO.login(userID, userPassword); //SHA256 유저이메일에 해당하는 해시값
	if(result == 1){
		//로그인성공
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}else if (result == 0 ){//비밀번호가 틀렸을때
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다.');");
		script.println("history.back();");//특정 페이지 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}else if (result == -1 ){//아이디가 존재하지 않을때
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back();");//특정 페이지 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}else if (result == -2 ){//아이디가 존재하지 않을때
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");//특정 페이지 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}

%>