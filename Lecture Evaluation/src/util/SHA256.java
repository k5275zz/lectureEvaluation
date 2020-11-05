package util;

import java.security.MessageDigest;

public class SHA256 {
//��256 ȸ������ ���Ŀ� �̸��� ������ �Ҷ� ������ �����ϴ� �̸��ϰ��� �ؽð��� �����ؼ� ����ڰ� �װ��� �����ڵ�� ��ũ�� Ÿ�� ���ͼ� ������ �Ҽ� �ֵ��� ���ִ°�
	
	public static String getSHA256(String input) {
		//Ư������ �־����� �ؽð��� ���ϴ� �޼ҵ�
		StringBuffer result = new StringBuffer();
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");//sha-256�������� ��ȣȭ
			byte[] salt = "Hello! This is Salt.".getBytes();//��Ŀ���� ���ݸ���
			digest.reset();
			digest.update(salt);
			byte[] chars = digest.digest(input.getBytes("UTF-8"));//���� �ؽ������
			for(int i =0;i<chars.length;i++) {
				String hex = Integer.toHexString(0xff & chars[i]);
				if(hex.length()==1) result.append("0");//hex.length:���ڿ����̱��ϱ�,���̰� 1�ڸ� �� �ϰ�� 0�� ���� 16������ �ٲ���
				result.append(hex);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();//toString() : ���� ���ڿ��� ��ȯ
	}
	
	
}
