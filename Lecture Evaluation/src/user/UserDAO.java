package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {
//실질적으로 유저데이터베이스에 접근할수 있도록 해주는곳
	public int login(String userID,String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setString(1, userID);//sql ?에 값넣기 >
			rs = pstmt.executeQuery();//sql 실행문 결과값 여기선 userPassword값 , ? userID에 맞는 유저패스워드
			if(rs.next()) {//rs.next() = sql실행결과가 존재하는지 확인
				if(rs.getString(1).equals(userPassword)) {
					return 1;//로그인 성공
				}
				else {
					return 0;//비밀번호 틀림
				}
			}
			return -1; //아이디가 존재하지 않음
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -2; //데이터베이스 오류
	}
	
	public int join(UserDTO user) {
		String SQL = "INSERT INTO USER VALUES(?,?,?,?,false)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setString(1, user.getUserID());//sql ?에 값넣기 >
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());
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
		return -1; //회원가입 실패
	}
	
	public boolean getUserEmailChecked(String userID) {//이메일검증이 확인이 되었는가
		String SQL = "SELECT userEmailChecked FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery(); //executeQuery : select문 , excuteUpdate : insert, delete, update
			if(rs.next()) {
				return rs.getBoolean(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return false; //데이터베이스 오류
	}
	
	public String getUserEmail(String userID) {//특정아이디의 이메일 값 반환 메소드
		String SQL = "SELECT userEmail FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setString(1, userID);
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
		return null; //데이터베이스 오류
	}
	
	public boolean setUserEmailChecked(String userID) {//이메일검증이 확인이 되었는가
		String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1또는 -1값으로 반환
			conn = DatabaseUtil.getConnection();//따로 데이터베이스 외부 util을 설정해줌으로써 안정적으로 모듈화
			pstmt = conn.prepareStatement(SQL);//sql문 실행 >pstmt담기
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
			return true;//사용자 이메일 인증 이미 인증이 되었다해도 마찬가지로 인증을 시켜줘야한다.
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//개체 닫아주기 (서버에 무리가 가지 않도록 닫아줌)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return false; //데이터베이스 오류
	}
}
