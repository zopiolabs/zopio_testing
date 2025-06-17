import type { UserContext } from "../types";
import { getAuth } from "@repo/auth/server";
import type { NextRequest } from "next/server";

// Define the expected structure of auth.sessionClaims
interface SessionClaims {
  metadata?: {
    role?: string;
  };
}

// Define the expected structure of auth
interface Auth {
  userId?: string;
  orgId?: string;
  sessionClaims?: SessionClaims;
}

export async function getUserContext(req: NextRequest): Promise<UserContext> {
  const auth = await getAuth(req) as Auth;
  
  if (!auth.userId || !auth.orgId || !auth.sessionClaims?.metadata?.role) {
    throw new Error("Unauthorized or incomplete session");
  }
  
  return {
    userId: auth.userId,
    role: auth.sessionClaims.metadata.role,
    tenantId: auth.orgId,
  };
}