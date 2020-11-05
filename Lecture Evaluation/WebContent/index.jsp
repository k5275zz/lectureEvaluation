<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>    
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
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
<%
	//인덱스페이지는 강의평가게시글을 출력해주기 때문에 항상 사용자가 어떤 게시글을 검색을 했는지 판단할수 있어야한다.
	request.setCharacterEncoding("UTF-8");
	String lectureDivide = "전체";
	String searchType= "최신순";
	String search = "";
	int pageNumber = 0;
	if(request.getParameter("searchType") != null){
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("lectureDivide") != null){
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("search") != null){
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null){
		//사용자가 입력한 값이 정수형이 아닌경우에는 오류가 발생하게해준다.
		try{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));	
		}catch(Exception e){
			System.out.println("검색 페이지 번호 오류");
		}
		
	}
	String userID = null;
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
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);//이메일인증이 안되었다면
	if(emailChecked == false){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendConfirm.jsp';");//다시 이메일인증 페이지 화면으로 이동
		script.println("</script>");
		script.close();
		return;//오류가 발생시 jsp파일을 종료시킨다.
	}
%>
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
      		<!-- 검색기능 구현 엑션은 index.jsp 메소드는 get방식으로 한다 -->
      		<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
      		<!-- 이중타입? 타입을 두개나 주는게 가능한가? 타입을 text로 그리고 name은 search로 준다.그럼 검색기능을 사용하면 get방식을 통해 url에 url+serach=검색어로 뜨게 된다 -->
      			<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
      			<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
      		</form>
      	</div>
	</nav>		
	<section class="container"> <!-- 컨테이너는 반응형으로 알아서 작아지는데 도움을 준다 -->
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>	
				<option value="전공" <% if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
				<option value="교양" <% if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
				<option value="기타" <% if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순" >최신순</option>	
				<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
				</select>  
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
		</form>
<%

	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();

	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);

	if(evaluationList != null)

	for(int i = 0; i < evaluationList.size(); i++) {

		if(i == 5) break;

		EvaluationDTO evaluation = evaluationList.get(i);

%>


		<div class="card bg-light mt-3">
			<div class="card-header bj-light">
				<div class="row">
					<div class="col-8 text-left"><%= evaluation.getLectureName() %>&nbsp;<small><%= evaluation.getProfessorName() %></small></div>
					<div class="col-4 text-right">
					종합<span style="color:red;"><%= evaluation.getTotalScore() %></span>
					</div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					<%= evaluation.getEvaluationTitle() %>&nbsp;<small>(<%= evaluation.getLectureYear() %>년<%= evaluation.getSemesterDivide() %>)</small>  <!-- &nbsp;게시판에 공백을 표현할수 있게 나타내는 것 -->
				</h5>
				<p class="card-text"><%= evaluation.getEvaluationContent() %></p>
				<div class="row">
					<div class="col-9 text-left">
						성적<span style="color:red;"><%= evaluation.getCreditScore() %></span>
						널널<span style="color:red;"><%= evaluation.getComfortableScore() %></span>
						강의<span style="color:red;"><%= evaluation.getLectureScore() %></span>	
						<span style="color:green;">(추천: <%= evaluation.getLikeCount() %>)</span>										
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">추천</a>
						<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">삭제</a>
						<!-- action페이지 뒤에 빼먹음 -->
					</div>
				</div>
			</div>
		</div>
<%
	}
	
%>
	</section>
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">

<%
	if(pageNumber <= 0 ){
%>		
        <a class="page-link disabled">이전</a>

<%

	} else {

%>

		<a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber - 1%>">이전</a>



<%
	}
%>
		
		</li>
		<li class="page-item">
<%

	if(evaluationList.size() < 6) {

%>     

        <a class="page-link disabled">다음</a>

<%

	} else {

%>

		<a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber + 1%>">다음</a>

<%

	}

%>

		</li>
		
	</ul>
	
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class= "modal-header">
					<h5 class="modal-title" id="modal">평가 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span> <!-- &times;닫기 아이콘 -->
					</button>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="form-row"> <!-- 한개의 행은 12만큼의 공간을 할당해준다. -->
							<div class="form-group col-sm-6">
								<label>강의명</label>
								<input type="text" name="lectureName" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
							 	<label>교수명</label>
								<input type="text" name="professorName" class="form-control" maxlength="20">
							</div>
						</div>
						<div class="form-row"> <!-- 한개의 행은 12만큼의 공간을 할당해준다. -->
							<div class="form-group col-sm-4">
								<label>수강 연도</label>
								<select name="lectureYear" class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
									<option value="2020" selected>2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강 학기</label>
								<select name="semesterDivide" class="form-control">
									<option value="1학기" selected>1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
									<option value="겨울학기">겨울학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의 구분</label>
								<select name="lectureDivide" class="form-control">
									<option value="전공" selected>전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>									
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height:180px;"></textarea>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label>종합</label>
								<select name="totalScore" class="form-control"> <!-- form-control 부트스트랩 기본양식 사용기능 -->
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>성적</label>
								<select name="creditScore" class="form-control"> <!-- form-control 부트스트랩 기본양식 사용기능 -->
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>널널한성적?</label>
								<select name="comfortableScore" class="form-control"> <!-- form-control 부트스트랩 기본양식 사용기능 -->
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>강의력</label>
								<select name="lectureScore" class="form-control"> <!-- form-control 부트스트랩 기본양식 사용기능 -->
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class= "modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span> <!-- &times;닫기 아이콘 -->
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label>신고 제목</label>
							<input type="text" name="reportTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>신고 내용</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height:180px;"></textarea>
						</div>						
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<footer class="bg-dark mt-4 p-5 text-center" style="color:#FFFFFF;">
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