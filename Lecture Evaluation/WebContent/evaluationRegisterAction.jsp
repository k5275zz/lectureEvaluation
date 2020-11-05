<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정한 스크립트 구문을 출력하고자 할때 사용. -->
<%//실제로 강의평가를 등록할 수 있는 액션 페이지
	request.setCharacterEncoding("UTF-8"); // 한글 파라미터 post 전송 경우
	String userID = null;//현재 로그인이 된 상태라면 막아준다.
	if(session.getAttribute("userID")!=null){
	userID = (String)session.getAttribute("userID");
	}	
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp';");//특정 페이지 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	
	String lectureName = null;
	String professorName = null;
	int lectureYear = 0;
	String semesterDivide = null;
	String lectureDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String creditScore = null;
	String comfortableScore = null;
	String lectureScore = null;
	
	if(request.getParameter("lectureName") != null){
		lectureName = request.getParameter("lectureName");
	}
	if(request.getParameter("professorName") != null){
		professorName = request.getParameter("professorName");
	}
	if(request.getParameter("lectureYear") != null){
		try{//lectureYear은 기본적으로 int형이라  사용자로 받은 값은 문자열로 오기에 형변환을 해줘야한다.
			lectureYear = Integer.parseInt(request.getParameter("lectureYear"));	
		} catch(Exception e){
			System.out.println("강의 연도 데이터 오류");
		}	
	}
	if(request.getParameter("semesterDivide") != null){
		semesterDivide = request.getParameter("semesterDivide");
	}
	if(request.getParameter("lectureDivide") != null){
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("evaluationTitle") != null){
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent") != null){
		evaluationContent = request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore") != null){
		totalScore = request.getParameter("totalScore");
	}
	if(request.getParameter("creditScore") != null){
		creditScore = request.getParameter("creditScore");
	}
	if(request.getParameter("comfortableScore") != null){
		comfortableScore = request.getParameter("comfortableScore");
	}
	if(request.getParameter("lectureScore") != null){
		lectureScore = request.getParameter("lectureScore");
	}
	//비어 있는 값이 있을시 오류 출력
	//컨텐트 제목과 내용은 공백일 경우도 제외해준다.
	if(lectureName == null || professorName == null || lectureYear == 0 || semesterDivide == null || lectureDivide == null
			|| evaluationTitle == null || evaluationContent == null|| totalScore == null || creditScore == null|| comfortableScore == null || lectureScore == null	
			|| evaluationTitle.equals("") || evaluationContent.equals("")
			){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	//실제로 회원가입 시키는 부분
	EvaluationDAO evaluationDAO = new EvaluationDAO() ;
	int result = evaluationDAO.write(new EvaluationDTO(0,userID,lectureName,professorName
			,lectureYear,semesterDivide,lectureDivide,evaluationTitle,evaluationContent,
			totalScore, creditScore, comfortableScore,lectureScore,0));
	
	if(result==-1){
		//강의평가등록 실패했을때
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 실패했습니다.');");
		script.println("history.back();");//이전 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}else {//성공하였다면 index페이지로 이동한다.
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");//특정 페이지 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
	//입력이 안된 사항 오류가 있을시 index페이지로 가서 확인
%>