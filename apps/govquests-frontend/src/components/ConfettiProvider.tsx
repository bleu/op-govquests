import {
  createContext,
  useContext,
  useState,
  useCallback,
  type ReactNode,
} from "react";
import Confetti from "react-confetti";

interface ConfettiContextType {
  triggerConfetti: () => void;
}

const ConfettiContext = createContext<ConfettiContextType | undefined>(
  undefined,
);

export const useConfetti = () => {
  const context = useContext(ConfettiContext);
  if (!context) {
    throw new Error("useConfetti must be used within a ConfettiProvider");
  }
  return context;
};

export const ConfettiProvider = ({ children }: { children: ReactNode }) => {
  const [explode, setExplode] = useState(false);

  const triggerConfetti = useCallback(() => {
    setExplode(true);
  }, []);

  return (
    <ConfettiContext.Provider value={{ triggerConfetti }}>
      {children}
      {explode && (
        <div className="fixed inset-0 z-50">
          <Confetti
            className="w-full h-full z-50"
            recycle={false}
            numberOfPieces={150}
            tweenDuration={500}
            gravity={0.3}
            wind={0.002}
            initialVelocityY={30}
            initialVelocityX={-10}
            confettiSource={{
              x: window.innerWidth / 2,
              y: window.innerHeight / 2,
              w: 0,
              h: 0,
            }}
            onConfettiComplete={() => setExplode(false)}
          />
        </div>
      )}
    </ConfettiContext.Provider>
  );
};
