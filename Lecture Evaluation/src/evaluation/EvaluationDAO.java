package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {
//�����򰡿� ���õ� �����ͺ��̽� ������ ���������� ���ִ� ��Ȱ ��ü
	
	//�۾��� �Լ�
	public int write(EvaluationDTO evaluationDTO) {
		//�� ���ڸ��� NULL�� �־��ִ� ������ evaluationID���� �ڵ����� 1�� �����ϴ� auto_increment ���� ��� �����̴�.
		//�� �� likecount�� 0���� �����̱� �����̴�.
		String SQL = "INSERT INTO EVALUATION VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,0)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			//ũ�ν������� ���� ���
			pstmt.setString(1, evaluationDTO.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("/r/n", "<br>"));//sql ?�� ���ֱ� >
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
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; //�����ͺ��̽� ����
	}
	//������ �˻� ��� �̾Ƴ���.���������� 5���� ������ ���ش�.
	public ArrayList<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber) {

		if(lectureDivide.equals("��ü")) {

			lectureDivide = "";

		}
		ArrayList<EvaluationDTO> evaluationList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;

		try {

			if(searchType.equals("�ֽż�")) {

				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? ORDER BY evaluationID DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;

			} else if(searchType.equals("��õ��")) {

				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? ORDER BY likeCount DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;

			}
			
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setString(1, "%" + lectureDivide + "%");//like�ϰ� %�ϰ� ���ڿ��� ������ �Ǹ� �� ���ڿ��� �����ϴ��� ����°�.�� lectureDivide�� ����ڰ� �Է��� ���ڿ��� �����ϴ��� ��ü�� ""�� �׻� �����ϴ� �ɷ� ǥ���ϰ�,������ ���� ���� ��Ÿ ���� ���� �ش���ڿ� ������ ����� ���
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();//sql ���๮ ����� ���⼱ userPassword�� , ? userID�� �´� �����н�����
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
	//Ư���� �� like ī���� 1���� ��Ű�� �޼ҵ�
	public int like(String evaluationID) {
		String SQL = "UPDATE EVALUATION SET LIKECOUNT = LIKECOUNT + 1 WHERE EVALUATIONID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setInt(1, Integer.parseInt(evaluationID));//evaluationID : �ڵ���ϵǴ� ��ȣ
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; //�����ͺ��̽� ����
	}
	//�� ���� �޼ҵ�
	public int delete(String evaluationID) {
		String SQL = "DELETE FROM EVALUATION WHERE EVALUATIONID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setInt(1, Integer.parseInt(evaluationID));//evaluationID : �ڵ���ϵǴ� ��ȣ
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//��ü �ݾ��ֱ� (������ ������ ���� �ʵ��� �ݾ���)
			try {if (conn != null) conn.close();}catch (Exception e) {e.printStackTrace();}
			try {if (pstmt != null) pstmt.close();}catch (Exception e) {e.printStackTrace();}
			try {if (rs != null) rs.close();}catch (Exception e) {e.printStackTrace();}
		}
		return -1; //�����ͺ��̽� ����
	}
	//Ư���� ������ ���ۼ��� ����� ���̵� �������� �޼ҵ�
	public String getUserID(String evaluationID) {
		System.out.println("aaa="+evaluationID);
		String SQL = "SELECT userID FROM Evaluation WHERE evaluationID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		try {//1�Ǵ� -1������ ��ȯ
			conn = DatabaseUtil.getConnection();//���� �����ͺ��̽� �ܺ� util�� �����������ν� ���������� ���ȭ
			pstmt = conn.prepareStatement(SQL);//sql�� ���� >pstmt���
			pstmt.setInt(1, Integer.parseInt(evaluationID));
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
		return null; // ���̵��� ���� ���
	}
	
}
