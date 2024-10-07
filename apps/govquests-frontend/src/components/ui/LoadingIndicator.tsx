import type React from "react";

const LoadingIndicator: React.FC = () => (
  <div className="flex items-center space-x-2">
    <div className="w-2 h-2 bg-gray-500 rounded-full animate-pulse" />
    <div className="w-2 h-2 bg-gray-500 rounded-full animate-pulse delay-75" />
    <div className="w-2 h-2 bg-gray-500 rounded-full animate-pulse delay-150" />
  </div>
);

export default LoadingIndicator;
