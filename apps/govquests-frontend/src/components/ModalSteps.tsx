import { cn } from "@/lib/utils";
import Image from "next/image";
import { useState } from "react";
import { Button } from "./ui/Button";
import { DialogContent, DialogFooter } from "./ui/dialog";
import HtmlRender from "./ui/HtmlRender";

export type ModalStep = {
  id: number;
  title: string;
  description: string;
  image: string;
};

export const ModalSteps = ({
  steps,
  ctaLastStep,
  handleClose,
}: {
  steps: ModalStep[];
  ctaLastStep: string;
  handleClose: () => void;
}) => {
  const [currentStep, setCurrentStep] = useState(steps[0]);

  const handleNext = () => {
    if (currentStep.id === steps.length) return;
    setCurrentStep(steps.find((step) => step.id === currentStep.id + 1));
  };

  const handlePrevious = () => {
    if (currentStep.id === 1) return;
    setCurrentStep(steps.find((step) => step.id === currentStep.id - 1));
  };

  return (
    <DialogContent
      className="max-w-md sm:rounded-3xl flex flex-col gap-6 p-5"
      hideCloseButton
    >
      <Image
        src={currentStep.image}
        alt={currentStep.title}
        width={1000}
        height={1000}
        className="w-full h-auto"
      />
      <div className="px-2.5 flex flex-col gap-6">
        <h1 className="text-xl font-bold">{currentStep.title}</h1>
        <p className="text-md text-muted-foreground">
          <HtmlRender content={currentStep.description} />
        </p>
      </div>
      {/* STEP INDICATORS */}
      <div className="flex gap-2 items-center justify-center mb-2">
        {steps.map((step) => (
          <div
            key={step.id}
            className={cn(
              "size-2 rounded-full bg-white/20",
              step.id === currentStep.id && "bg-white",
            )}
          />
        ))}
      </div>
      <DialogFooter className="flex items-center justify-between w-full">
        <Button
          variant="secondary"
          className="w-full py-3 h-fit font-bold"
          onClick={handlePrevious}
        >
          Previous
        </Button>
        <Button
          className="w-full py-3 h-fit font-bold"
          onClick={currentStep.id === steps.length ? handleClose : handleNext}
        >
          {currentStep.id === steps.length ? ctaLastStep : "Next"}
        </Button>
      </DialogFooter>
    </DialogContent>
  );
};
