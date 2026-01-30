import React from 'react';

// Fix: Added React import to resolve "Cannot find namespace 'React'" error when using React.ReactNode
export interface InputProps {
  label: string;
  placeholder: string;
  type?: string;
  icon?: React.ReactNode;
  value: string;
  onChange: (val: string) => void;
  isPassword?: boolean;
}
