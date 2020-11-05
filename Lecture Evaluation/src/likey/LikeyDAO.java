package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class LikeyDAO {

	public int like(String userID,String evaluationID,String userIP) {
		String SQL = "INSERT INTO LIKEY VALUES(?,?,?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setString(1,userID);//sql ?에 값넣기 >
			pstmt.setString(2,evaluationID);
			pstmt.setString(3,userIP);
	
			return pstmt.executeUpdate(); //executeQuery : select문 , excuteUpdate : insert, delete, update
			//영향을 받을 데이터값의 갯수값을 반환/ 성공적으로 회원가입이 이루어 졌다면 1명의 정보가 추가 1이라는 값을 반환한다.
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; // 추천 중복 오류
	}
	
}
