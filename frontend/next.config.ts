import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Docker standalone output 설정 추가
  output: 'standalone',

  /**
   * API 프록시 설정
   */
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        // 환경변수 BACKEND_URL이 설정되어 있으면 해당 주소로, 없으면 로컬 백엔드로 전달
        destination: `${process.env.BACKEND_URL || 'http://localhost:8080'}/api/:path*`,
      },
    ];
  },
};

export default nextConfig;
