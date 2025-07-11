package template_kotlin;

import java.util.regex.Pattern;

public class PatternChecker {
    // 정규식 패턴 정의
    private static final Pattern SIMPLE_PATTERN = Pattern.compile("^#\\{[^}]+}$");
    private static final Pattern HTTPS_PATTERN = Pattern.compile("^https://#\\{[^}]+}$");
    private static final Pattern HTTP_PATTERN = Pattern.compile("^http://#\\{[^}]+}$");

    public static boolean matchesPattern(String input) {
        if (input == null) return false;
        return SIMPLE_PATTERN.matcher(input).matches()
            || HTTPS_PATTERN.matcher(input).matches()
            || HTTP_PATTERN.matcher(input).matches();
    }

    public static void main(String[] args) {
        String[] testCases = {
            "#{username}",
            "https://#{hostname}",
            "http://#{hostname}",
            "http://#{id}",
            "https://#{api.url}",
            "#{incomplete",
            "just a string",
            "#{complete}ewaeawewaeaweawe",
            "ftp://#{wrong}"
        };

        for (String testCase : testCases) {
            System.out.printf("Input: %-30s => Match: %s%n", testCase, matchesPattern(testCase));
        }
    }

}
