"use client";

import { useEffect, useState } from "react";

export function CursorHighlight() {
  const [position, setPosition] = useState({ x: 0, y: 0 });
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const updateCursorPosition = (e) => {
      setPosition({ x: e.clientX, y: e.clientY });
      setIsVisible(true);
    };

    const handleMouseLeave = () => {
      setIsVisible(false);
    };

    window.addEventListener("mousemove", updateCursorPosition);
    document.body.addEventListener("mouseleave", handleMouseLeave);

    return () => {
      window.removeEventListener("mousemove", updateCursorPosition);
      document.body.removeEventListener("mouseleave", handleMouseLeave);
    };
  }, []);

  return (
    <div
      className={`fixed pointer-events-none z-0 rounded-full bg-white/10 blur-xl transition-opacity duration-300 ${isVisible ? "opacity-100" : "opacity-0"}`}
      style={{
        width: "200px",
        height: "200px",
        transform: `translate(${position.x - 100}px, ${position.y - 150}px)`,
        transition: "transform 0.2s ease-out",
      }}
    />
  );
}