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
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setString(1,userID);//sql ?�� ���ֱ� >
			pstmt.setString(2,evaluationID);
			pstmt.setString(3,userIP);
	
			return pstmt.executeUpdate(); //executeQuery : select�� , excuteUpdate : insert, delete, update
			//������ ���� �����Ͱ��� �������� ��ȯ/ ���������� ȸ�������� �̷�� ���ٸ� 1���� ������ �߰� 1�̶�� ���� ��ȯ�Ѵ�.
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; // ��õ �ߺ� ����
	}
	
}
