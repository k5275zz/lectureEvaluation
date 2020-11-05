package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {
//강의평가와 관련된 데이터베이스 접근을 직접적으로 해주는 역활 객체
	
	//글쓰기 함수
	public int write(EvaluationDTO evaluationDTO) {
		//맨 앞자리에 NULL을 넣어주는 이유는 evaluationID값은 자동으로 1씩 증가하는 auto_increment 값을 줬기 때문이다.
		//맨 뒤 likecount는 0부터 시작이기 때문이다.
		String SQL = "INSERT INTO EVALUATION VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,0)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			//크로스사이팅 공격 방어
			pstmt.setString(1, evaluationDTO.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));//sql ?에 값넣기 >
			pstmt.setString(2, evaluationDTO.getLectureName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(3, evaluationDTO.getProfessorName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setInt(4, evaluationDTO.getLectureYear());
			pstmt.setString(5, evaluationDTO.getSemesterDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(6, evaluationDTO.getLectureDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(7, evaluationDTO.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(8, evaluationDTO.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(9, evaluationDTO.getTotalScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(10, evaluationDTO.getCreditScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(11, evaluationDTO.getComfortableScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			pstmt.setString(12, evaluationDTO.getLectureScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; //데이터베이스 오류
	}
	//강의평가 검색 결과 뽑아내기.한페이지당 5개씩 나오게 해준다.
	public ArrayList<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber) {

		if(lectureDivide.equals("전체")) {

			lectureDivide = "";

		}
		ArrayList<EvaluationDTO> evaluationList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;

		try {

			if(searchType.equals("최신순")) {

				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? ORDER BY evaluationID DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;

			} else if(searchType.equals("추천순")) {

				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? ORDER BY likeCount DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;

			}
			
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setString(1, "%" + lectureDivide + "%");//like하고 %하고 문자열이 들어오게 되면 그 문자열을 포함하는지 물어보는것.즉 lectureDivide가 사용자가 입력한 문자열을 포함하는지 전체는 ""로 항상 포함하는 걸로 표현하고,나머지 전공 교양 기타 같은 경우는 해당글자와 동일한 결과만 출력
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();//sql 실행문 결과값 여기선 userPassword값 , ? userID에 맞는 유저패스워드
			evaluationList = new ArrayList<EvaluationDTO>();

			while(rs.next()) {

				EvaluationDTO evaluation = new EvaluationDTO(

					rs.getInt(1),

					rs.getString(2),

					rs.getString(3),

					rs.getString(4),

					rs.getInt(5),

					rs.getString(6),

					rs.getString(7),

					rs.getString(8),

					rs.getString(9),

					rs.getString(10),

					rs.getString(11),

					rs.getString(12),

					rs.getString(13),

					rs.getInt(14)

				);

				evaluationList.add(evaluation);

			}

		} catch (Exception e) {

			e.printStackTrace();

		} finally {

			try {

				if(rs != null) rs.close();

				if(pstmt != null) pstmt.close();

				if(conn != null) conn.close();

			} catch (Exception e) {

				e.printStackTrace();

			}

		}

		return evaluationList;

	}
	//특정한 글 like 카운터 1증가 시키는 메소드
	public int like(String evaluationID) {
		String SQL = "UPDATE EVALUATION SET LIKECOUNT = LIKECOUNT + 1 WHERE EVALUATIONID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setInt(1, Integer.parseInt(evaluationID));//evaluationID : 자동등록되는 번호
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; //데이터베이스 오류
	}
	//글 삭제 메소드
	public int delete(String evaluationID) {
		String SQL = "DELETE FROM EVALUATION WHERE EVALUATIONID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setInt(1, Integer.parseInt(evaluationID));//evaluationID : 자동등록되는 번호
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; //데이터베이스 오류
	}
	//특정한 강의평가 글작성한 사람의 아이디를 가져오는 메소드
	public String getUserID(String evaluationID) {
		System.out.println("aaa="+evaluationID);
		String SQL = "SELECT userID FROM Evaluation WHERE evaluationID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			rs = pstmt.executeQuery(); //executeQuery : select문 , excuteUpdate : insert, delete, update
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return null; // 아이디값이 없는 경우
	}
	
}

