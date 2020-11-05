package util;

import java.security.MessageDigest;

public class SHA256 {
//샤256 회원가입 이후에 이메일 인증을 할때 기존에 존재하던 이메일값에 해시값을 적용해서 사용자가 그것을 인증코드로 링크를 타고 들어와서 인증을 할수 있도록 해주는것
	
	public static String getSHA256(String input) {
		//특정값을 넣었을때 해시값을 구하는 메소드
		StringBuffer result = new StringBuffer();
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");//sha-256형식으로 암호화
			byte[] salt = "Hello! This is Salt.".getBytes();//해커들의 공격막기
			digest.reset();
			digest.update(salt);
			byte[] chars = digest.digest(input.getBytes("UTF-8"));//실제 해쉬값담기
			for(int i =0;i<chars.length;i++) {
				String hex = Integer.toHexString(0xff & chars[i]);
				if(hex.length()==1) result.append("0");//hex.length:문자열길이구하기,길이가 1자리 수 일경우 0을 더해 16진수로 바꿔줌
				result.append(hex);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();//toString() : 값을 문자열로 변환
	}
	
	
}
