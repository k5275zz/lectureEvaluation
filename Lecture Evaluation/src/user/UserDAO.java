package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {
//���������� ���������ͺ��̽��� �����Ҽ� �ֵ��� ���ִ°�
	public int login(String userID,String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setString(1, userID);//sql ?�� ���ֱ� >
			rs = pstmt.executeQuery();//sql ���๮ ����� ���⼱ userPassword�� , ? userID�� �´� �����н�����
			if(rs.next()) {//rs.next() = sql�������� �����ϴ��� Ȯ��
				if(rs.getString(1).equals(userPassword)) {
					return 1;//�α��� ����
				}
				else {
					return 0;//��й�ȣ Ʋ��
				}
			}
			return -1; //���̵� �������� ����
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -2; //�����ͺ��̽� ����
	}
	
	public int join(UserDTO user) {
		String SQL = "INSERT INTO USER VALUES(?,?,?,?,false)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setString(1, user.getUserID());//sql ?�� ���ֱ� >
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());
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
		return -1; //ȸ������ ����
	}
	
	public boolean getUserEmailChecked(String userID) {//�̸��ϰ����� Ȯ���� �Ǿ��°�
		String SQL = "SELECT userEmailChecked FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery(); //executeQuery : select�� , excuteUpdate : insert, delete, update
			if(rs.next()) {
				return rs.getBoolean(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return false; //�����ͺ��̽� ����
	}
	
	public String getUserEmail(String userID) {//Ư�����̵��� �̸��� �� ��ȯ �޼ҵ�
		String SQL = "SELECT userEmail FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery(); //executeQuery : select�� , excuteUpdate : insert, delete, update
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return null; //�����ͺ��̽� ����
	}
	
	public boolean setUserEmailChecked(String userID) {//�̸��ϰ����� Ȯ���� �Ǿ��°�
		String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
			return true;//����� �̸��� ���� �̹� ������ �Ǿ����ص� ���������� ������ ��������Ѵ�.
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return false; //�����ͺ��̽� ����
	}
}
