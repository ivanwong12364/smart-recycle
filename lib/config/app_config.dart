class AppConfig {
  static const String apiKey =
      'sk-UXj4Dr6u5JFXh4k51e165aA31e75466c995c67Ca05DbE360';

  // API 配置
  static const String apiEndpoint = 'https://free.v36.cm/v1/chat/completions';

  // ChatGPT 配置
  static const String model = 'gpt-4o-mini';
  static const int maxTokens = 300;

  // 图片配置
  static const double maxImageWidth = 800;
  static const double maxImageHeight = 800;
  static const int imageQuality = 85;

  // API 请求配置
  static Map<String, String> getHeaders() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

  // ChatGPT 提示语配置
  static const String systemPrompt =
      'You are a recycling expert. Your task is to analyze images of items and '
      'categorize them as Paper, Plastic, Metal, or Other. Provide brief, clear explanations.';

  static const String userPrompt =
      'What type of recyclable item is this? Please categorize it and explain briefly.';
}
